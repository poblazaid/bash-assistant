#!/bin/bash
# needed packages: hostapd-util bash
# run with: hostapd_cli -a wifi-presence.sh
# replace lines 20 & 33 with the commands you want to run when an user arrives / leaves 
# enter below the names of the people & the MAC addresses of the devices you want to monitor

declare -A users=(
  ["pablo"]="ab:cd:5f:03:cb:1a aa:de:5f:8a:57:f2"
  ["coco"]="ab:cd:55:03:cb:1a ac:bd:5f:8a:57:f2"
)
declare -a mac_addresses

if [[ $2 == "AP-STA-CONNECTED" ]]
then
  for user in ${!users[@]}; do
    mac_addresses=(${users[$user]})
    for mac in ${mac_addresses[@]}; do
      if [[ $3 == $mac ]]
        then
        echo $user " is home"
      fi
    done
  done
fi

if [[ $2 == "AP-STA-DISCONNECTED" ]]
then
  for user in ${!users[@]}; do
    mac_addresses=(${users[$user]})
    for mac in ${mac_addresses[@]}; do
      if [[ $3 == $mac ]]
        then
        echo $user " left home"
      fi
    done
  done
fi
