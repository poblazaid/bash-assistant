#!/bin/bash
# needed packages: hostapd-util bash
# run with: hostapd_cli -a wifi-presence.sh
# replace in line 31 phy1-ap0 with the wifi interface you want to monitor
# replace lines 22 & 47 with the commands you want to run when an user arrives / leaves 
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
        echo 1 > /var/run/$user.present
        echo $user " is home"
      fi
    done
  done
fi

if [[ $2 == "AP-STA-DISCONNECTED" ]]
then
  readarray -t connected_clients< <(iwinfo  phy1-ap0 assoclist | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
  for user in ${!users[@]}; do
    is_connected="0"
    mac_addresses=(${users[$user]})
    for mac in ${mac_addresses[@]}; do
      for client in ${connected_clients[@]}; do
        if [ $mac != $3 ] && [ ${mac^^} == $client ]
          then
          echo $user " is still home"
          is_connected="1"
        fi
      done
    done
    if [[ $is_connected == "0" ]]
      then
      echo $user " left home"
      echo 0 > /var/run/$user.present
    fi
  done
fi
