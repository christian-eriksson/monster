#!/bin/sh

sassc -t compact gtk-3.0/main.scss compiled-theme/gtk-3.0/gtk.css
cp -r gtk-2.0 compiled-theme
