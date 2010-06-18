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
    if not pynotify.init('Work monitor'):
        return
    parser = OptionParser()
    parser.add_option('-d', '--delay', type='int', action='store', dest='sleep_time', help='How long must we sleep before checking again?', default=60)
    options, args = parser.parse_args()
    options.sleep_time = max(options.sleep_time, 60) # at least 60 seconds

    n = None
    while True:
        if n is not None:
            n.close()
        title = 'How much did I work?'
        total_day_time = total_time_of()
        total_week_time = total_time_for_this_week()
        msg = 'Worked 8 hours today? %s\n\n' % ('Yes' if total_day_time >= datetime.timedelta(hours=8) else 'No')
        msg += 'Worked 40 hours this week? %s' % ('Yes' if total_week_time >= datetime.timedelta(hours=40) else 'No')
        n = pynotify.Notification(title, msg)
        if total_day_time >= datetime.timedelta(hours=8, minutes=00) or total_week_time >= datetime.timedelta(hours=40, minutes=00):
            n = pynotify.Notification(title, msg, 'dialog-error')
        elif total_day_time >= datetime.timedelta(hours=7, minutes=45) or total_week_time >= datetime.timedelta(hours=39, minutes=45):
            n = pynotify.Notification(title, msg, 'dialog-warning')
        elif total_day_time >= datetime.timedelta(hours=7, minutes=30) or total_week_time >= datetime.timedelta(hours=39, minutes=30):
            n = pynotify.Notification(title, msg, 'dialog-info')
        n.set_urgency(pynotify.URGENCY_CRITICAL)
        n.set_timeout(4)
        n.show()
        time.sleep(options.sleep_time)

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s %(levelname)s %(message)s',
                        filename='/tmp/show_song.log',
                        filemode='a')
    total_time = total_time_of()
    print total_time
    print 'Worked 8 hours? %s' % ('yes' if total_time >= datetime.timedelta(hours=8) else 'no')
    total_time = total_time_for_this_week()
    print total_time
    print 'Worked 40 hours? %s' % ('yes' if total_time >= datetime.timedelta(hours=40) else 'no')
    main()
