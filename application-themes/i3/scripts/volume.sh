#!/bin/sh

high_icon=${ICON_HIGH:-""}
medium_icon=${ICON_MEDIUM:-""}
low_icon=${ICON_LOW:-""}
off_icon=${ICON_OFF:-""}

volume=$(pamixer --get-volume)
if [ "$(pamixer --get-mute)" == "false" ] && [ "${volume}" -gt "0" ]; then
  full_text=" $(pamixer --get-volume-human)"

  if [ "${volume}" -gt "70" ]; then
    icon=$high_icon
  elif [ "${volume}" -gt "30" ]; then
    icon=$medium_icon
  else
    icon=$low_icon
  fi
else
  full_text=" OFF"
  icon=$off_icon
  muted="muted"
fi

[ "${markup}" = "pango" ] && [ -n "${FONT}" ] && full_text="<span font_family=\"${FONT}\">${full_text}</span>"

full_text="${icon}${full_text}"
echo "${full_text}"

short_text=$full_text
echo "${short_text}"

[ -n "${muted}" ] && echo "${NOTICE_COLOR}"

exit 0
