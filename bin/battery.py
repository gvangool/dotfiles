#!/usr/bin/env python
# -*- coding: utf-8 -*-
import re
import subprocess
import sys

def read_battery_charge():
    '''
    Reads battery charge percentage
    '''
    def _read(sp, regex):
        process = subprocess.Popen(sp, stdout=subprocess.PIPE)
        output = process.communicate()[0].strip()
        return int(re.search(regex, output, re.MULTILINE).group(1))

    # OSX
    if sys.platform.startswith('darwin'):
        # Using "pmset -g batt"
        charge = _read(['pmset', '-g', 'batt'], r'^.+\t([\d]+)\%')
    # Linux
    else:
        # Using "acpi -b"
        charge = _read(['acpi', '-b'], r'^Battery 0: .+, ([\d]+)\%')
    return charge

# output
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'emoji':
        print u'🔋',
    elif len(sys.argv) > 1 and sys.argv[1] == 'ascii':
        print u' B',
    else:
        print ' ',
    print '%d%%' % read_battery_charge()
