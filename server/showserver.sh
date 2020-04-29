#!/bin/bash
#
#
#

# get the server process line from ps
SERVER_PROC=`ps aux | grep runserver | grep django | tr -s " "`

if [ "$SERVER_PROC" == "" ]; then
    echo "No server"
else
    # get the server parent PID, ...
    PID=`echo $SERVER_PROC | cut -d " " -f 2`
    START=`echo $SERVER_PROC | cut -d " " -f 9`
    ADDR_PORT=`echo $SERVER_PROC | cut -d " " -f 14`
    ADDR=`echo $ADDR_PORT | cut -d ":" -f 1`
    PORT=`echo $ADDR_PORT | cut -d ":" -f 2`

    echo "Server running on port ${PORT} at ${ADDR} with a PID of ${PID} since ${START}"
fi



# end file

