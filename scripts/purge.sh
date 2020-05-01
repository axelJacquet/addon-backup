#!/bin/bash

set -x
set -e

host=$(hostname -a)
now=`date +%s`
time_limit=$(($now + 7200))

. /home/.config/swissbackup/openrc.sh

usage2() {  1>&2; exit 1; }

while getopts "s:h:d:w:m:y:" o; do
    case "${o}" in

        s)
            last_snapshot=${OPTARG}
            ;;


        h)
            hour=${OPTARG}
            ;;
        d)
            day=${OPTARG}
            ;;
        w)
            week=${OPTARG}
            ;;

        m)
            month=${OPTARG}
            ;;

        y)
            year=${OPTARG}
            ;;
    esac
done
shift $((OPTIND-1))

while true
	do
		if [ $now -gt $timelimit  ]
		then
			echo "`date +'%Y%m%d%H%M'`: Timeout. exiting "
			exit 1
		elif [ `restic list locks --no-lock | wc -l` -gt 0 ]
		then
			echo "`date +'%Y%m%d%H%M'`: Backup waiting for lock" > /root/retention.log
		else
			echo "`date +'%Y%m%d%H%M'`: Deleting $p" > /root/retention.log
	                eval "/usr/bin/restic forget --host $host --keep-within "$year"y"$month"m"$day"d"$hour"h --prune" > /root/retention.log
			break
		fi
		sleep 60
	done


> /home/plan.json

function loopOverArray(){
         restic snapshots --json | jq -r '.?' | jq -c '.[]'| while read i; do
           id=$(echo "$i" | jq -r '.| .short_id')
              ctime=$(echo "$i" | jq -r '.| .time' | cut -f1 -d".")
                  paths=$(echo "$i" | jq -r '. | .paths | join(",")')
            hostname=$(echo $i | jq -r '.| .hostname')

       printf "{\"id\":%-s, \"date\":%-s, \"path\":%-s, \"name\":%-s}," \"$id\" \"$ctime\" \"$paths\" \"$hostname\"

               done
              }
             function parse(){
              local res=$(loopOverArray)
       echo "[$res]" | sed 's/\(.*\),/\1 /' >> /home/plan.json
          }
         parse
