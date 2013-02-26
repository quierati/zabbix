#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
[ -z $(type -p nfsstat) ] && echo 13 && exit 13
MOUNT=$(awk '/nfs /  || / glusterfs / && !/^#/ {print $2}' /etc/fstab|wc -l)
MOUNTED=$(nfsstat -m|awk '/from/ {print $1}'|wc -l)
[[ $MOUNT < $MOUNTED ]] && { echo 10; exit 10; }
STATUS=$((($MOUNT - $MOUNTED) * -1))
echo $STATUS
exit $STATUS

