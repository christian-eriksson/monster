#!/bin/sh

set -e

dconf_path="/org/gnome/terminal/legacy/profiles:"
profile_path="compiled-theme/application-themes/terminal/gnome-terminal-profile.dconf"
uuid=$(cat compiled-theme/application-themes/terminal/theme-uuid)
installed_profiles=$(dconf read /org/gnome/terminal/legacy/profiles:/list)
installed_profiles=${installed_profiles%?}

[ -n "${installed_profiles}" ] && monster_installed=$(echo "${installed_profiles}" | grep $uuid)

if [ -z "${monster_installed}" ]; then
  if [ -z "${installed_profiles}" ]; then
    dconf write "${dconf_path}/list"  "['${uuid}']"
  else
    dconf write "${dconf_path}/list"  "${installed_profiles}, '${uuid}']"
  fi
fi

dconf write "${dconf_path}/default"  "'${uuid}'"

dconf load "${dconf_path}/:${uuid}/" < $profile_path

echo "term theme installed"

