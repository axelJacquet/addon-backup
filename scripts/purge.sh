#!/bin/bash

set -x
set -e

now=`date +%s`
time_limit=$(($now + 7200))

. /home/.config/swissbackup/openrc.sh

while true
        do
                if [ $now -gt $timelimit  ]
                then
                        echo "`date +'%Y%m%d%H%M'`: Timeout. exiting "
						exit 1
                elif [ `restic list locks --no-lock | wc -l` -gt 0 ]
                then
                        echo "`date +'%Y%m%d%H%M'`: Backup waiting for lock"
                else
                        echo "`date +'%Y%m%d%H%M'`: Deleting"
                        delete
                fi
                sleep 60
        done
