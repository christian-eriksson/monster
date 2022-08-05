#!/bin/sh

set -e

MONSTER_PATH=$(dirname $(realpath $0))
[ -z "$SUDO_USER" ] && real_user=$(whoami) || real_user=$SUDO_USER
home_dir=$(getent passwd "${real_user}" | cut -d: -f6)

grep -vFf $MONSTER_PATH/application-themes/terminal/.Xresources-patterns $home_dir/.Xresources >$home_dir/.Xresources.tmp
mv $home_dir/.Xresources.tmp $home_dir/.Xresources
cat $MONSTER_PATH/application-themes/terminal/.Xresources >>$home_dir/.Xresources

grep -vFf $MONSTER_PATH/application-themes/terminal/.Xresources-patterns /root/.Xresources >/root/.Xresources.tmp
mv /root/.Xresources.tmp /root/.Xresources
cat $MONSTER_PATH/application-themes/terminal/.Xresources >>/root/.Xresources

xrdb -merge $home_dir/.Xresources

echo "zutty term theme installed"
