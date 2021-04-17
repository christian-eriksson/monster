#!/bin/sh
COMPILE_DIR=compiled-theme
GTK3_DIR=gtk-3.0
GTK2_DIR=gtk-2.0
ASSETS_DIR=assets
APPLICATION_THEMES_DIR=application-themes

mkdir -p $COMPILE_DIR/gtk/$GTK3_DIR/
sassc -t compact $GTK3_DIR/main.scss $COMPILE_DIR/gtk/$GTK3_DIR/gtk.css
cp -r $GTK2_DIR $COMPILE_DIR/gtk
cp -r $ASSETS_DIR $COMPILE_DIR/gtk
cp -r $APPLICATION_THEMES_DIR $COMPILE_DIR