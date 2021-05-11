#!/bin/sh

usage() {
  echo "Usage: ./build.sh <home_dir> <base_i3_config_path> [<i3blocks_disk_config>]"
}

[ -z "$1" ] && echo -e "Please provide a home dir for the user!\n" && usage && exit 1
HOME_DIR=${1%/}

[ -z "$2" ] && echo -e "Please provide the path to a base i3 config!\n" && usage && exit 1
BASE_I3_CONFIG_PATH=$2

I3BLOCKS_DISK_CONFIG_PATH=$3

COMPILE_DIR=compiled-theme
GTK3_DIR=gtk-3.0
GTK2_DIR=gtk-2.0
ASSETS_DIR=assets
APPLICATION_THEMES_DIR=application-themes

rm -rf $COMPILE_DIR
mkdir -p $COMPILE_DIR/gtk/$GTK3_DIR/
sassc -t compact $GTK3_DIR/main.scss $COMPILE_DIR/gtk/$GTK3_DIR/gtk.css
sassc -t compact $GTK3_DIR/app-specific.scss $COMPILE_DIR/gtk/$GTK3_DIR/app-specific.css
cp -r $GTK2_DIR $COMPILE_DIR/gtk
cp -r $ASSETS_DIR $COMPILE_DIR/gtk
cp -r $APPLICATION_THEMES_DIR $COMPILE_DIR

I3BLOCKS_CONF_PATH=${COMPILE_DIR}/${APPLICATION_THEMES_DIR}/i3/i3blocks.conf
sed -i -e "s\{{HOME_DIR}}\\${HOME_DIR}\g" $I3BLOCKS_CONF_PATH

DISK_ENTRIES=$(cat "${I3BLOCKS_DISK_CONFIG_PATH}" 2>/dev/null | tr "\n" "@")
I3BLOCKS_CONF=$(sed -e "s%{{DISK_ENTRIES}}%${DISK_ENTRIES}%" $I3BLOCKS_CONF_PATH)
echo "$I3BLOCKS_CONF" | tr "@" "\n" > $I3BLOCKS_CONF_PATH

COMPILED_I3_CONFIG=${COMPILE_DIR}/${APPLICATION_THEMES_DIR}/i3/config

echo "##################################
###### GENERATED BY MONSTER ######
# PLEASE EDIT THE BASE CONFIG AND
# RE-BUILD RATHER THAN EDITING
# THIS FILE
##################################" > ${COMPILED_I3_CONFIG}

cat ${BASE_I3_CONFIG_PATH} >> ${COMPILED_I3_CONFIG}

echo "##################################
###### GENERATED BY MONSTER ######
# ANYTHING ABOVE COMES FROM THE
# BASE CONFIG.
#
# (EDIT THERE NOT HERE)
#
# ANYTHING BELOW THIS LINE IS
# GENERATED BY MONSTER
##################################" >> ${COMPILED_I3_CONFIG}

for file in ${COMPILE_DIR}/${APPLICATION_THEMES_DIR}/i3/partial-configs/*; do
    if [ -f "$file" ]; then
        cat "$file" >> ${COMPILED_I3_CONFIG}
    fi
done

echo "##################################
###### GENERATED BY MONSTER ######
# EDIT BASE CONFIG NOT HERE
##################################" >> ${COMPILED_I3_CONFIG}
