#!/usr/bin/env bash

# echo_isp()
# {
#   curl --noproxy '*' ip-api.com/line?fields=isp
# }

main()
{
  if result=$(curl --noproxy "*" "ip-api.com/line?fields=isp" 2>/dev/null); then
    echo "🔗 ${result}"
    return 0
  else
    echo "🔌 Offline"
    return 1
  fi
}

main
