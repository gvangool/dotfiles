#!/usr/bin/env python
import datetime
import hamster.client
import logging
from optparse import OptionParser
import sys
import time

try:
    import pynotify
except ImportError:
    logging.error('No pynotify installed')
    sys.exit(1)

def total_time_of(date=None):
    s = hamster.client.Storage()
    if date is None or date == datetime.date.today():
        facts = s.get_todays_facts()
    else:
        facts = s.get_facts(date)
    total_time = None
    for fact in facts:
        end_time = datetime.datetime.now() if fact['end_time'] is None else fact['end_time']
        t = end_time - fact['start_time']
        if total_time is None:
            total_time = t
        else:
            total_time += t

    return total_time

def total_time_for_this_week():
    today = datetime.date.today()
    dates = [today - datetime.timedelta(days=i) for i in range(0, today.weekday() + 1)]
    total_time = None
    for d in dates:
        t = total_time_of(d)
        if total_time is None:
            total_time = t
        elif t is not None:
            total_time += t
    return total_time

def main():
    parser = OptionParser()
    parser.add_option('-d', '--delay', type='int', action='store', dest='sleep_time', help='How long must we sleep before checking again?', default=60)
    parser.add_option('-t', '--hours-a-day', type='int', action='store', dest='hours_a_day', help='How many hours a day should you work?', default=8)
    parser.add_option('-w', '--hours-a-week', type='int', action='store', dest='hours_a_week', help='How many hours a week do you work?', default=40)
    options, args = parser.parse_args()
    options.sleep_time = max(options.sleep_time, 60) # at least 60 seconds

    hours_a_day = {'error': datetime.timedelta(hours=options.hours_a_day),
                   'warning': datetime.timedelta(hours=options.hours_a_day) - datetime.timedelta(minutes=15),
                   'info': datetime.timedelta(hours=options.hours_a_day) - datetime.timedelta(minutes=30)}
    hours_a_week = {'error': datetime.timedelta(hours=options.hours_a_week),
                    'warning': datetime.timedelta(hours=options.hours_a_week) - datetime.timedelta(minutes=15),
                    'info': datetime.timedelta(hours=options.hours_a_week) - datetime.timedelta(minutes=30)}

    if not pynotify.init('Work monitor'):
        return
    while True:
        title = 'Time Tracker'
        msg = ''
        total_day_time = total_time_of()
        total_week_time = total_time_for_this_week()
        if total_day_time is not None:
            if total_day_time >= hours_a_day['error'] or total_week_time >= hours_a_week['error']:
                msg = 'Go home!'
                icon = 'dialog-error'
            elif total_day_time >= hours_a_day['warning'] or total_week_time >= hours_a_week['warning']:
                msg = 'Don\'t forget to finish everyting...'
                icon = 'dialog-warning'
            elif total_day_time >= hours_a_day['info'] or total_week_time >= hours_a_week['info']:
                msg = 'Worked hours today? <b>%dh</b>\n\n' % (total_day_time.seconds / (60*60),)
                msg += 'Worked hours this week? <b>%dh</b>' % (total_week_time.days * 24 + total_week_time.seconds / (60*60),)
                icon = 'hamster-applet'

            if msg != '':
                n = pynotify.Notification(title, msg, icon)
                n.set_urgency(pynotify.URGENCY_CRITICAL)
                n.set_timeout(4 * 1000)
                n.show()
        try:
            time.sleep(options.sleep_time)
        except KeyboardInterrupt:
            break

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s %(levelname)s %(message)s',
                        filename='/tmp/hamster_timer.log',
                        filemode='a')
    total_time = total_time_of()
    print total_time
    print 'Worked 8 hours? %s' % ('yes' if total_time >= datetime.timedelta(hours=8) else 'no')
    total_time = total_time_for_this_week()
    print total_time
    print 'Worked 40 hours? %s' % ('yes' if total_time >= datetime.timedelta(hours=40) else 'no')
    main()
