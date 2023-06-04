#!/bin/sh

[ -z "$INTERFACES" ] && exit 1

ethernet_icon=${ETHERNET_ICON:-""}
wifi_icon=${WIFI_ICON:-"直"}
full_icon=${WIFI_FULL:-"▁▃▅▇"}
high_icon=${WIFI_HIGH:-"▁▃▅"}
medium_icon=${WIFI_MEDIUM:-"▁▃"}
low_icon=${WIFI_LOW:-"▁"}
lowest_icon=${WIFI_LOWEST:-""}
no_wifi_icon=${NO_WIFI:-"睊"}
network_off=${NETWORK_OFF:-""}

prioritized_route=$(ip route get 8.8.8.8 | head -n1 | awk '{ print $5";"$7 }')
full_text="NO NETWORK"
icon=$network_off
for interface in $INTERFACES; do
  if [ $(echo $prioritized_route | grep -c "$interface") -eq 1 ]; then
    ip_address=$(echo $prioritized_route | cut -d";" -f2)
    full_text=$ip_address
    icon=$ethernet_icon
    signal_strength=$(iwctl station $interface show | grep AverageRSSI | awk '{ print $2 }')
    if [ -n "${signal_strength}" ]; then
      icon="${wifi_icon}"
      if [ "${signal_strength}" -lt "-90" ]; then
        icon="${no_wifi_icon}"
      elif [ "${signal_strength}" -lt "-80" ]; then
        signal_strength_icon="${lowest_icon}"
      elif [ "${signal_strength}" -lt "-70" ]; then
        signal_strength_icon="${low_icon}"
      elif [ "${signal_strength}" -lt "-67" ]; then
        signal_strength_icon="${medium_icon}"
      elif [ "${signal_strength}" -lt "-30" ]; then
        signal_strength_icon="${high_icon}"
      else
        signal_strength_icon="${full_icon}"
      fi
    fi
    break
  fi
done

[ -n "${icon}" ] && full_text=" ${full_text}"

# if [ "${markup}" = "pango" ] && [ -n "${FONT}" ]; then
#   signal_strength_icon="<span padding-bottom=\"0.2em\">${signal_strength_icon}</span>"
#   full_text="<span font_family=\"${FONT}\">${full_text}</span>"
# fi

[ "${markup}" = "pango" ] && [ -n "${FONT}" ] && full_text="<span font_family=\"${FONT}\">${full_text}</span>"
[ "${markup}" = "pango" ] && [ -n "${FONT}" ] && signal_strength_icon="<span rise=\"6pt\">${signal_strength_icon}</span>"

echo "${icon}${signal_strength_icon}${full_text}"

short_text=$full_text
echo "${short_text}"

[ -z "${ip_address}" ] && echo "${NOTICE_COLOR}"

exit 0
