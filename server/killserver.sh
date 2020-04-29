#!/bin/bash
#
# Find the server PID and kill (soft) it.
#

PID=`ps aux | grep runserver | grep django | tr -s " " | cut -d " " -f 2`

if [ "${PID}" == ""  ]; then
    echo "Unable to get server PID"
else
    echo "Killing server with PID $PID"
    kill $PID
fi

# end file
