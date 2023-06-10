#!/bin/sh

set -e

default_source_info=$(pacmd list-sources | grep -e 'index:'  -e 'device.bus =' -e 'device.string =' -e 'name:' | paste - - - - | grep '\* index:')
if echo "${default_source_info}" | grep -q "bluetooth"; then
  # echo >&2 "BLUETOOTH SOURCE"
  default_device=$(echo "${default_source_info}" | grep -o 'device.string = "\([0-9A-Z]\{2\}:\)\{5\}[0-9A-Z]\{2\}"' | awk '{ print substr($3,2,length($3)-2) }')
  device_name=$(echo "${default_source_info}" | grep -o 'name: <[0-9a-zA-Z_:+.-]\+>' | awk '{ print substr($2,2,length($2)-2) }')
  active_profile=$(echo "${device_name}" | rev | cut -d'.' -f1 | rev)
  # echo >&2 "BLUETOOTH DEVICE & PROFILE"
else
  # echo >&2 "BLUETOOTH CARD"
  bluetooth_cards_info=$(pacmd list-cards | grep -e "index:" -e "device.bus =" -e "device.string =" -e "active profile" | paste - - - - | grep "bluetooth" || echo "")
  if [ -n "${bluetooth_cards_info}" ]; then
    # echo >&2 "HAS BLUETOOTH CARDS"
    while read bluetooth_card_info; do
        # echo >&2 "FIND BLUETOOTH DEVICE & PROFILE"
        default_device=$(echo "${bluetooth_card_info}" | grep -o 'device.string = "\([0-9A-Z]\{2\}:\)\{5\}[0-9A-Z]\{2\}"' | awk '{ print substr($3,2,length($3)-2) }')
        active_profile=$(echo "${bluetooth_card_info}" | grep -o 'active profile: <[0-9a-zA-Z_:+.-]\+>' | awk '{ print substr($3,2,length($3)-2) }')
        if [ -n "${active_profile}" && "${active_profile}" = "off" ]; then
          # echo >&2 "DEVICE AND PROFILE FOUND"
          break
        fi
    done < <(echo "${bluetooth_cards_info}")

    # echo >&2 "DEVICE AND PROFILE FOUND"
    [ -z "${active_profile}" ] && active_profile="off"
  fi
  # echo >&2 "BLUETOOTH CARD DEVICE & PROFILE"
fi

if [ -n "${button}" ] && [ -n "${default_device}" ] && [ -n "${active_profile}" ]; then
  # echo >&2 "CLICKED TO GET NEXT PROFILE"
  profiles=""
  profile_count=0
  next_profile_index=1
  parsing_device="false"
  parsing_profiles="false"
  while read -r line; do
    # echo >&2 "FINDING NEXT PROFILE"
    if [ "${parsing_profiles}" = "true" ]; then
      # echo >&2 "FOUND PROFILES"
      if echo "${line}" | grep -q "active profile:"; then
        # echo >&2 "LOOPED THROUGH PROFILES"
        break
      fi

      profile=$(echo "${line}" | cut -d":" -f1)
      profiles="${profiles}${profile};"
      profile_count=$((profile_count+1))

      if [ "${profile}" = "${active_profile}" ]; then
        # echo >&2 "SET NEXT PROFILE"
        next_profile_index=$((profile_count+1))
      fi
    fi

    if echo "${line}" | grep -q "index:"; then
      # echo >&2 "SET CARD INDEX"
      card_index=$(echo "${line}" | awk '{ print $2 }')
    fi

    if [ "${parsing_device}" = "true" ]; then
      if [ "${line}" = "profiles:" ]; then
        # echo >&2 "START PARSING PROFILES"
        parsing_profiles="true"
      fi
    fi

    if echo "${line}" | grep -q "${default_device}"; then
      # echo >&2 "START PARSING DEVICES & SET CARD INDEX"
      parsing_device="true"
      default_card_index="${card_index}"
    fi
  done < <(pacmd list-cards | grep -e "index:" -e "device.string =" -e "profiles:" -A10 | grep ":" || echo "")

  if [ "${next_profile_index}" -gt "${profile_count}" ]; then
    # echo >&2 "START FROM FIRST PROFILE"
    next_profile_index=1
  fi

  # echo >&2 "SET PROFILE"
  next_profile=$(echo "${profiles}" | cut -d";" -f$next_profile_index)
  pacmd set-card-profile $default_card_index $next_profile
fi

# echo >&2 "DISPLAY ACTIVE PROFILE"
[ -n "${next_profile}" ] && active_profile="${next_profile}"

if [ "${active_profile}" = "a2dp_sink" ]; then
  icon=${ICON_HEADPHONES:-""}
elif [ "${active_profile}" = "handsfree_head_unit" ]; then
  icon=${ICON_HEADSET:-""}
elif [ "${active_profile}" = "off" ]; then
  icon=${ICON_DISABLED:-""}
  disabled="true"
else
  icon=""
  disabled="true"
  # enable debug in 40-bar.conf to read this in output files
  echo >&2 "unrecognized profile: ${active_profile}"
fi

full_text="${icon}"
echo "${full_text}"

short_text="${full_text}"
echo "${short_text}"

[ -n "${disabled}" ] && echo "${NOTICE_COLOR}"

exit 0
