#!/bin/sh

usage() {
  echo "Usage: ./build.sh <base_i3_config_path>"
}

[ -z "$1" ] && echo -e "Please provide the path to a base i3 config!\n" && usage && exit 1
BASE_I3_CONFIG_PATH=$1

COMPILE_DIR=compiled-theme
GTK3_DIR=gtk-3.0
GTK2_DIR=gtk-2.0
ASSETS_DIR=assets
APPLICATION_THEMES_DIR=application-themes

mkdir -p $COMPILE_DIR/gtk/$GTK3_DIR/
sassc -t compact $GTK3_DIR/main.scss $COMPILE_DIR/gtk/$GTK3_DIR/gtk.css
sassc -t compact $GTK3_DIR/app-specific.scss $COMPILE_DIR/gtk/$GTK3_DIR/app-specific.css
cp -r $GTK2_DIR $COMPILE_DIR/gtk
cp -r $ASSETS_DIR $COMPILE_DIR/gtk
cp -r $APPLICATION_THEMES_DIR $COMPILE_DIR

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
