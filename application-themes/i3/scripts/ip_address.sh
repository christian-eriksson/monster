#!/bin/sh

[ -z "$INTERFACES" ] && exit 1

prioritized_route=$(ip route get 8.8.8.8 | head -n1 | awk '{ print $5";"$7 }')
full_text="NO NETWORK"
for interface in $INTERFACES; do
  if [ $(echo $prioritized_route | grep -c "$interface") -eq 1 ]; then
    ip_address=$(echo $prioritized_route | cut -d";" -f2)
    full_text=$ip_address
    break
  fi
done

[ -n "${label}" ] && full_text=" ${full_text}"

[ "${markup}" = "pango" ] && [ -n "${FONT}" ] && full_text="<span font_family=\"${FONT}\">${full_text}</span>"

echo "${full_text}"

short_text=$full_text
echo "${short_text}"

[ -z "${ip_address}" ] && echo "${NOTICE_COLOR}"

exit 0
