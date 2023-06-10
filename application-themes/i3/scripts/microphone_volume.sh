#!/bin/sh

set -e

[ -z "${1}" ] && exit 0

input="${1}"

default_source_info=$(pacmd list-sources | grep -e 'index:' -e 'muted:' -e "volume steps:" | paste - - - | grep '\* index:')

[ -z "${default_source_info}" ] && exit 0

source_index=$(echo "${default_source_info}" | awk '{ print $3}')
max_volume=$(echo "${default_source_info}" | awk '{ print $6 }')
mute_state=$(echo "${default_source_info}" | awk '{ print $8 }')

if [ "$input" = "toggle-mute" ]; then
  if [ "${mute_state}" = "yes" ]; then
    pacmd set-source-mute $source_index 0
  else
    pacmd set-source-mute $source_index 1
  fi
else
  volume_dump=$(pacmd dump-volumes | grep "Source ${source_index}:")
  if echo "${volume_dump}" | grep -q "mono"; then
    left_volume=$(echo "${volume_dump}" | awk '{ print $6 }')
    right_volume="${left_volume}"
  else
    left_right_volumes=$(echo "${volume_dump}" | awk '{ print $6";"$13 }')
    left_volume=$(echo "${left_right_volumes}" | cut -d";" -f1)
    right_volume=$(echo "${left_right_volumes}" | cut -d";" -f2)
  fi

  if [ "${left_volume}" -gt "${right_volume}" ]; then
    volume_info=" ${left_volume}"
    volume="${left_volume}"
  else
    volume_info=" ${right_volume}"
    volume="${right_volume}"
  fi

  echo $volume
  echo $input
  echo $max_volume
  new_volume=$((volume + input))
  if [ "${new_volume}" -lt "0" ]; then
    new_volume=0
  fi

  if [ "${new_volume}" -gt "${max_volume}" ]; then
    new_volume=$max_volume
  fi

  echo $new_volume
  pacmd set-source-volume "${source_index}" "${new_volume}"
fi
