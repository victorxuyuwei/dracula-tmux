#!/usr/bin/env bash

# echo_isp()
# {
#   curl --noproxy '*' ip-api.com/line?fields=isp
# }

main()
{
  result=$(curl --noproxy '*' ip-api.com/line?fields=isp)
  if [ $? -eq 0 ]; then
    echo "🔗 $result"
  else
    echo "🔌 Offline"
  fi
}

main