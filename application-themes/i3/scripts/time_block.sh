#!/bin/sh

date_str=$(date '+%Y-%m-%d %H:%M ')

full_text=${date_str}

[ -n "${label}" ] && full_text=" ${full_text}"

[ "${markup}" = "pango" ] && [ -n "${FONT}" ] && full_text="<span font_family=\"${FONT}\">${full_text}</span>"

echo "$full_text"
