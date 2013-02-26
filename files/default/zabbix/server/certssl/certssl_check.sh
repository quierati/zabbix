#!/bin/bash

TMOUT=10
HOST=${1:-labunix.com}
PORT=${2:-443}

EXPIRES=$(timeout $TMOUT openssl s_client -host $HOST -port $PORT -showcerts  < /dev/null 2>/dev/null| sed -n '/BEGIN CERTIFICATE/,/END CERT/p' | openssl x509 -enddate -noout 2>/dev/null | sed -e 's/^.*\=//')

date -d "${EXPIRES}" 2>/dev/null 1>/dev/null
[ $? -ne 0 ] && exit 1

DATE=$(date "+%s")
ENDDATE=$(date "+%s" --date "${EXPIRES}")

echo $((($ENDDATE - $DATE)/24/3600))


