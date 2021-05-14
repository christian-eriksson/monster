#!/bin/sh

dconf_path="/org/gnome/terminal/legacy/profiles:"
profile_path="compiled-theme/application-themes/terminal/gnome-terminal-profile.dconf"
uuid=$(cat compiled-theme/application-themes/terminal/theme-uuid)
installed_profiles=$(dconf read /org/gnome/terminal/legacy/profiles:/list)
installed_profiles=${installed_profiles%?}

monster_installed=$(echo "${installed_profiles}" | grep $uuid)

[ -z "${monster_installed}" ] && dconf write "${dconf_path}/list"  "${installed_profiles}, '${uuid}']"

dconf load "${dconf_path}/:${uuid}/" < $profile_path