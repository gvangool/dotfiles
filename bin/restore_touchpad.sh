#!/bin/bash

# Restart synaptics touchpad on resume, see
# https://help.ubuntu.com/community/SynapticsTouchpad for more information.
# To enable it, copy it to /etc/pm/sleep.d/98gsynaptics
#   sudo cp restore_touchpad.sh /etc/pm/sleep.d/98gsynaptics

# Only run on resume/thaw
if [[ ${1} =~ (thaw|resume) ]] ; then

  synaptics() {

    # sleep to give time for X
    sleep 4s

    who | while read line ; do
      a=(${line})
      regex="^:[[:digit:]]"
      if [[ ${a[1]} =~ $regex ]] ; then
        init="sudo -H -u ${a[0]} DISPLAY=${a[1]} gsynaptics-init"
        eval "${init}"
      fi
    done
  }

  # run in background so sleep doesn't hold up resume
  synaptics &
  # disown so exiting shell doesn't kill function
  disown %1

fi
