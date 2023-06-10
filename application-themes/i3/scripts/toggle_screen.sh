#!/bin/sh

set -e

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

if [ "${current_mode}" = "single" ]; then
    # next mode: extended
    max_hdmi_resolution=$(xrandr | grep -A1 "HDMI-1 connected" | tail -n1 | awk '{ print $1 }')

    hdmi_x_resolution=$(echo $max_hdmi_resolution | cut -d"x" -f1)
    hdmi_y_resolution=$(echo $max_hdmi_resolution | cut -d"x" -f2)

    ([ -z "$hdmi_x_resolution" ] || [ -z "$hdmi_y_resolution" ]) && echo "not connected!" && exit 1

    x_scaling=$(echo "3200/$hdmi_x_resolution" | bc -l)
    y_scaling=$(echo "1800/$hdmi_y_resolution" | bc -l)

    aspect_ratio=$(echo "$hdmi_y_resolution/$hdmi_x_resolution" | bc -l)

    # For screens with larger hight (y) we want to use the smaller scaling factor
    # in order to fill the extended screen fully
    if [ "$(echo "$aspect_ratio>0.5625" | bc -l)" -eq "1" ]; then
        [ "$(echo "$y_scaling<$x_scaling" | bc -l)" -eq "1" ] && scaling=$y_scaling || scaling=$x_scaling
    else
        [ "$(echo "$y_scaling>$x_scaling" | bc -l)" -eq "1" ] && scaling=$y_scaling || scaling=$x_scaling
    fi

    xrandr --output eDP-1 --mode 3200x1800 --primary --pos 0x0 --output HDMI-1 --mode $max_hdmi_resolution --scale "$scaling"x"$scaling" --pos 0x-1800
elif [ "${current_mode}" = "extended" ]; then
    # next mode: mirror
    max_hdmi_resolution=$(xrandr | grep -A1 "HDMI-1 connected" | tail -n1 | awk '{ print $1 }')
    xrandr --output eDP-1 --mode 3200x1800 --output HDMI-1 --mode $max_hdmi_resolution --same-as eDP-1
else
    # next mode: single
    xrandr --output eDP-1 --primary --auto --scale 1x1 --output HDMI-1 --off
fi
