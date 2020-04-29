#!/bin/bash
#
# * This script should be run from a virtenv, see 'actviate'
# * The python instance used is /home/gmorgan/.virtualenvs/djangodev/bin/python
#

DJANGO_HOST=0.0.0.0
DJANGO_PORT=8000

# convert arg 1 to lower case
if [ "${1,,}" == "debug" ]; then
    DEBUG=1
else
    DEBUG=0
fi

VENV=`set | grep VIRTUAL_ENV=`

if [ "${VENV}" == "" ]; then
    echo "No virtual enviroment found. You must be running in a virtual enviroment to run the test server. Use 'source activate' to enter the virtual environment."
    exit 1
else
    # this is for debugging
    VENV_NAME=`echo ${VENV} | grep virtualenvs | cut -d "/" -f 5`
    echo "Running in virtual enviroment: ${VENV_NAME}"
fi

echo "Starting server ..."

if [ "${DEBUG}" == "1" ]; then
    python manage.py runserver ${DJANGO_HOST}:${DJANGO_PORT}
else
    python manage.py runserver ${DJANGO_HOST}:${DJANGO_PORT} &> ./server.log &

    RETVAL=$?

    sleep 1

    if [ "${RETVAL}" == "0" ]; then
        SERVER_PROC=`ps aux | grep runserver | grep django | tr -s " "`
        PID=`echo $SERVER_PROC | cut -d " " -f 2`
        ADDR_PORT=`echo $SERVER_PROC | cut -d " " -f 14`
        ADDR=`echo $ADDR_PORT | cut -d ":" -f 1`
        PORT=`echo $ADDR_PORT | cut -d ":" -f 2`
        # alt cmd to get port, stderr to stdout is due to sudo warning
        #netstat -panlW 2>&1 | grep "${PID}" | grep python

        if [ "$PID" == ""  ]; then
            echo "Starting server ... unable to get server PID"
        else
            if [ "$ADDR_PORT" == ""  ]; then
              echo "Starting server ... started with PID ${PID}. Unable to get server address:port"
            else
              echo "Starting server ... started with PID ${PID} on port ${PORT} at ${ADDR}"
            fi
        fi
    else
        echo "Starting server ... start failed with exit code ${RETVAL}"
    fi
fi


# end file
