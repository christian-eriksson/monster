#!/bin/sh

set -e

usage() {
  echo "Usage: ./install.sh <terminal>"
}

[ -z "$1" ] && printf "Please provide the name of your terminal emulator\n" && usage && exit 1
terminal=$1

MONSTER_PATH=$(dirname $(realpath $0))
[ -z "$SUDO_USER" ] && real_user=$(whoami) || real_user=$SUDO_USER
home_dir=$(getent passwd "${real_user}" | cut -d: -f6)

mkdir -p $home_dir/.themes
ln -sf $MONSTER_PATH/compiled-theme/gtk $home_dir/.themes/monster
mkdir -p $home_dir/.config/gtk-3.0/
ln -sf $MONSTER_PATH/compiled-theme/gtk/gtk-3.0/app-specific.css $home_dir/.config/gtk-3.0/gtk.css
mkdir -p $home_dir/.config/term-themes
mkdir -p /root/.config/term-themes
ln -sf $MONSTER_PATH/compiled-theme/application-themes/terminal/ $home_dir/.config/term-themes/monster
ln -sf $MONSTER_PATH/compiled-theme/application-themes/terminal/ /root/.config/term-themes/monster
mkdir -p $home_dir/.config/feh
mkdir -p $home_dir/.wallpapers
ln -sf $MONSTER_PATH/compiled-theme/application-themes/desktop/fehbg $home_dir/.config/feh/fehbg
ln -sf $MONSTER_PATH/compiled-theme/application-themes/picom $home_dir/.config/
mkdir -p $home_dir/.local/bin
ln -sf $MONSTER_PATH/compiled-theme/application-themes/i3/scripts $home_dir/.local/bin/i3blocks
mkdir -p $home_dir/.local/share/rofi/themes
ln -sf $MONSTER_PATH/compiled-theme/application-themes/rofi/monster.rasi $home_dir/.local/share/rofi/themes
mkdir -p $home_dir/.config/rofi
ln -sf $MONSTER_PATH/compiled-theme/application-themes/rofi/config.rasi $home_dir/.config/rofi
mkdir -p $home_dir/.config/i3
ln -sf $MONSTER_PATH/compiled-theme/application-themes/i3/i3blocks.conf $home_dir/.config/i3/
ln -sf $MONSTER_PATH/compiled-theme/application-themes/i3/config $home_dir/.config/i3/

grep -vFf $MONSTER_PATH/compiled-theme/application-themes/gtk-3.0-patterns $home_dir/.config/gtk-3.0/settings.ini >$home_dir/.config/gtk-3.0/settings.ini.tmp
mv $home_dir/.config/gtk-3.0/settings.ini.tmp $home_dir/.config/gtk-3.0/settings.ini
cat $MONSTER_PATH/compiled-theme/application-themes/gtk-3.0-install >>$home_dir/.config/gtk-3.0/settings.ini

grep -vFf $MONSTER_PATH/compiled-theme/application-themes/terminal/.bashrc-patterns $home_dir/.bashrc >$home_dir/.bashrc.tmp
mv $home_dir/.bashrc.tmp $home_dir/.bashrc
cat $MONSTER_PATH/compiled-theme/application-themes/terminal/.bashrc-install >>$home_dir/.bashrc

chown -R $real_user:$real_user $home_dir/.themes/monster \
  $home_dir/.config/gtk-3.0 $home_dir/.config/term-themes $home_dir/.config/feh \
  $home_dir/.wallpapers $home_dir/.local/bin $home_dir/.local/share/rofi/themes \
  $home_dir/.config/rofi $home_dir/.config/i3 $home_dir/.bashrc \
  $home_dir/.config/picom

if [ "${terminal}" = "gnome-terminal" ]; then
  $MONSTER_PATH/install-gnome-terminal-profile.sh
elif [ "${terminal}" = "zutty" ]; then
  $MONSTER_PATH/install-zutty-terminal-theme.sh
else
  echo "WARNING: terminal emulator '${terminal}' is not recognized"
fi
