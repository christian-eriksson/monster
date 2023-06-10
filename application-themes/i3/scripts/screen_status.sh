#!/bin/sh

set -e

if [ -n "${button}" ]; then
    $SCRIPT_DIR/toggle_screen.sh
fi

active_monitors=$(xrandr --listactivemonitors | tail -n+2)
monitor_count=$(echo "${active_monitors}" | wc -l)

if [ "$monitor_count" -lt "2" ]; then
    current_mode="single"
else
    y_axis_offset=$(xrandr --listactivemonitors | tail -n+2 | grep '\*' | awk '{ print $3 }' | cut -d"+" -f3)
    if [ "${y_axis_offset}" -gt "0" ]; then
        current_mode="extended"
    else
        current_mode="mirror"
    fi
fi

if [ "${current_mode}" = "extended" ]; then
    icon=${EXTENED_ICON:-""}
elif [ "${current_mode}" = "mirror" ]; then
    icon=${MIRROR_ICON:-""}
else
    icon=${SINGLE_ICON:-""}
fi

full_text="${icon}"
echo "${full_text}"

short_text="${full_text}"
echo "${short_text}"

exit 0
