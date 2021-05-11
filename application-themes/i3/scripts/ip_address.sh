#!/bin/sh

[ -z "$INTERFACE" ] && exit 1

ip_address=$(ip address show $INTERFACE | grep -o "inet \([1-9]\{0,3\}\.\)\{3\}[1-9]\{0,3\}" | awk '{print $2}')

if [ -n "${ip_address}" ]; then
  full_text=$ip_address
else
  full_text="NO NETWORK"
fi

[ -n "${label}" ] && full_text=" ${full_text}"

[ "${markup}" = "pango" ] && [ -n "${FONT}" ] && full_text="<span font_family=\"${FONT}\">${full_text}</span>"

echo "${full_text}"

short_text=$full_text
echo "${short_text}"

[ -z "${ip_address}" ] && echo "${NOTICE_COLOR}"

exit 0
