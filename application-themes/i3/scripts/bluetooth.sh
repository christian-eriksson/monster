#!/bin/sh

set -e

# icon options:
#    

battery_0="";
battery_10="";
battery_20="";
battery_30="";
battery_40="";
battery_50="";
battery_60="";
battery_max="";

device_statuses=$(rfkill | grep "bluetooth" | awk '{ print $4";"$5 }')
if [ "$(echo $device_statuses | cut -d';' -f1)" = "blocked" ] || [ "$(echo $device_statuses | cut -d';' -f2)" = "blocked" ]; then
    icon=${DISABLED_ICON:-""}
    disabled="true"
else
    icon=${ENABLED_ICON:-""}
fi

while read -r device; do
    device_id=$(echo $device | awk '{ print $2 }')
    device_name=$(echo $device | awk '$1=$2=""; { print $0 }')
    if [ -z "${device_id}" ] || [ -z "${device_name}" ]; then
        continue
    fi
    device_info=$(bluetoothctl info $device_id || true)
    if echo "$device_info" | grep -iq "no default controller"; then
        icon=${DISABLED_ICON:-""}
        disabled="true"
        break
    fi
    connection_status=$(echo "${device_info}" | grep "Connected:" | awk '{ print $2 }')
    if [ "${connection_status}" = "yes" ]; then
        icon=${CONNECTED_ICON:-""}
        connected_device="${device_name}"
        battery_percentage=$(echo "${device_info}" | grep -i "Battery Percentage:" | grep -o "(.*)" | grep -o "[[:digit:]]\+")
        break
    fi
done < <(bluetoothctl devices)

if [ -n "${connected_device}" ]; then
    info="${connected_device}"
    if [ -n "${battery_percentage}" ]; then
        if [ "${battery_percentage}" -gt "69" ]; then
            battery_icon=" ${battery_max}"
        elif [ "${battery_percentage}" -gt "59" ]; then
            battery_icon=" ${battery_60}"
        elif [ "${battery_percentage}" -gt "49" ]; then
            battery_icon=" ${battery_50}"
        elif [ "${battery_percentage}" -gt "39" ]; then
            battery_icon=" ${battery_40}"
        elif [ "${battery_percentage}" -gt "29" ]; then
            battery_icon=" ${battery_30}"
            battery_color="${NOTICE_COLOR}"
        elif [ "${battery_percentage}" -gt "19" ]; then
            battery_icon=" ${battery_20}"
            battery_color="${WARNING_COLOR}"
        elif [ "${battery_percentage}" -gt "9" ]; then
            battery_icon=" ${battery_10}"
            battery_color="${CRITICAL_COLOR}"
        else
            battery_icon=" ${battery_0}"
            battery_color="${CRITICAL_COLOR}"
        fi
    fi

    if [ "${markup}" = "pango" ] && [ -n "${FONT}" ]; then
        if [ -n "${battery_color}" ]; then
            battery_info="<span foreground=\"${battery_color}\">${battery_icon}</span>"
        else
            battery_info="${battery_icon}"
        fi
        info="<span font_family=\"${FONT}\">${info}${battery_info}</span>"
    else
        info="${info}${battery_icon}"
    fi
fi

echo "${icon}${info}"
echo $icon

[ -n "${disabled}" ] && echo "${NOTICE_COLOR}"

exit 0