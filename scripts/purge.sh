#!/bin/bash

set -x
set -e

now=`date +%s`
time_limit=$(($now + 7200))

. /home/.config/swissbackup/openrc.sh

usage () {
        echo "$0 --folders-to-backup <folder1>[,folder2,folder3,...]"
        exit 1
}
for i in $@ ; do
        case "${1}" in
        "--folders-to-backup"|"-f")
        echo $1
                if [ -z "${2}" ] ; then
                        echo "No parameter defining the --folder-to-backup parameter"
                        usage
                fi
                FOLDER_TO_BACKUP="${2}"
                shift
                shift
        ;;
        *)
        ;;
        esac
done

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
                        echo "`date +'%Y%m%d%H%M'`: Backup waiting for lock"
                else
                        echo "`date +'%Y%m%d%H%M'`: Deleting"
                        delete
                fi
                sleep 60
        done
