#!/bin/sh

set -e

default_mic_state=$(pacmd list-sources | grep -e "index:" -e "muted:" | paste - - | grep "\*")

source_index=$(echo "${default_mic_state}" | awk '{ print $3 }')
volume_dump=$(pacmd dump-volumes | grep "Source ${source_index}:")
if echo "${volume_dump}" | grep -q "mono"; then
  left_human_volume=$(echo "${volume_dump}" | awk '{ print $8 }')
  right_human_volume="${left_human_volume}"
else
  left_right_volumes=$(echo "${volume_dump}" | awk '{ print $8";"$15 }')
  left_human_volume=$(echo "${left_right_volumes}" | cut -d";" -f1)
  right_human_volume=$(echo "${left_right_volumes}" | cut -d";" -f2)
fi

left_volume=${left_human_volume%?}
right_volume=${right_human_volume%?}

if [ "${left_volume}" -gt "${right_volume}" ]; then
  volume_info=" ${left_human_volume}"
  volume="${left_volume}"
else
  volume_info=" ${right_human_volume}"
  volume="${right_volume}"
fi

mute_state=$(echo "${default_mic_state}" | awk '{ print $5 }')
muted=""
if [ "${mute_state}" == "yes" ] || [ "${volume}" -lt "1" ]; then
  icon=${ICON_OFF:-""}
  muted="true"
elif [ "${volume}" -lt "20" ]; then
  icon=${ICON_LOW:-""}
else
  icon=${ICON:-""}
fi

full_text="${volume_info}"
[ "${markup}" = "pango" ] && [ -n "${FONT}" ] && full_text="<span font_family=\"${FONT}\">${volume_info}</span>"

full_text="${icon}${full_text}"
echo "${full_text}"

short_text=$full_text
echo "${short_text}"

[ -n "${muted}" ] && echo "${NOTICE_COLOR}"

exit 0
