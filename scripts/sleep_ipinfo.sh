#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

LOCKFILE=/tmp/.dracula-tmux-ipinfo.lock
DATAFILE=/tmp/.dracula-tmux-ipinfo

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
  
  if [ ! -f $DATAFILE ]; then
    printf "Loading..." > $DATAFILE
  fi

  $current_dir/ip_info.sh > $DATAFILE
  
  while tmux has-session &> /dev/null
  do
    $current_dir/ip_info.sh > $DATAFILE
    if tmux has-session &> /dev/null
    then
      if cat $DATAFILE | grep Offline &> /dev/null; then
        sleep 20
      else
        sleep 3600
      fi
    else
      break
    fi
  done

  rm $LOCKFILE
}

main