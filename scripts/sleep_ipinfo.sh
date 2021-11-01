#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

LOCKFILE=/tmp/.dracula-tmux-ipinfo.lock
DATAFILE=/tmp/.dracula-tmux-ipinfo
LOGFILE=/tmp/dracula.log

ensure_single_process()
{
  # check for another running instance of this script and terminate it if found
  [ -f $LOCKFILE ] && ps -p "$(cat $LOCKFILE)" -o cmd= | grep -F " ${BASH_SOURCE[0]}" && kill "$(cat $LOCKFILE)"
  echo $$ > $LOCKFILE
}

main()
{
  ensure_single_process

  current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  # if [ ! -f $DATAFILE ]; then
  echo "Loading..." > $DATAFILE
  # fi

  # ${current_dir}/ip_info.sh $DATAFILE
  # echo $result > $DATAFILE

  # tmux session not build so fast and may cause follow script not get into
  sleep 0.5

  while tmux has-session &> /dev/null
  do
    if result=$(${current_dir}/ip_info.sh); then
      echo $result > $DATAFILE
      # echo "$(date -Is): online and sleep 3600" >> $LOGFILE
      sleep 3600
    else
      echo $result > $DATAFILE
      # echo "$(date -Is): offline and sleep 20" >> $LOGFILE
      sleep 20
    fi
  done

  rm $LOCKFILE
}

main
