#!/bin/bash
#
# Apache Log Collect
#
# description: Script to collect the Apache error codes and  send via Zabbix trapper
# version: 1.0
# scriptname: apachelog_collect.sh
# date: Tue Dec 11 17:40:46 BRST 2012
# Labunix.com
# Julio Quierati <julio.quierati@gmail.com>



ZTMP=$(mktemp)
HOST=$(hostname)
LOG="/var/log/apache2/access.log"
trap "rm -rf $ZTMP" 0 

[ ! -e $LOG ] && { echo 1; exit 1; } 

awk -v host=$HOST '
    BEGIN { error20x=0; error30x=0; error40x=0; error50x=0; } 
     { if (!/nagios/ && !/Zabbix/ && !/Varnish/) 
       if (/" 20[0-9] /) error20x++
       else if (/- 30[0-9] /) error30x++ 
       else if (/- 4[0-1][0-9] /) error40x++
       else if (/- 50[0-9] /) error50x++
     }  
    END { 
       printf ("%s apache_error20x %d\n%s apache_error30x %d\n%s apache_error40x %d\n%s apache_error50x %d\n",host, error20x,host, error30x,host, error40x,host, error50x)
    }' $LOG >> $ZTMP

[ ! -z $1 ] && cat $ZTMP

zabbix_sender -z zabbix.example.com -i $ZTMP >&-
ZS=$?
echo $ZS
exit $ZS

