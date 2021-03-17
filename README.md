# Monster

A pretty monster for theming GTK 2 and GTK 3 applications using the i3 window manager.

> **Note:** As the theme is made for i3 it might not look as good with other window managers.

## Install

To install the theme:

```
clone <repository>
ln -sf <repository-path>/compiled-theme ~/.themes/monster
```

Use something like `lxappearance` to select and activate the theme.

## Dependencies

If you want to make changes you'll need the following:

- `sassc`

If you want to test the theme you'll need a couple of GTK applications at least one GTK 2 and one GTK 3 application. For example:

- PCManFM (GTK 3)
- Double Commander (GTK 2)

## Compile Theme

To compile the theme (if you have made changes):

```
cd <repository-path>
sassc -t compact gtk-3.0/main.scss compiled-theme/gtk-3.0/gtk.css
```

## Inspirations

The main inspirations for monster are:

- [Pacific-Blue Theme](https://www.gnome-look.org/p/1295782/)
  - The `gtkrc*` files for the GTK 2 part of the theme comes directly from this theme, though the colors have been modified to fit monster.
- [AdMin](https://github.com/nrhodes91/AdMin)
  - The way we organize scss files for the GTK 3 parts are inspired by this theme.
