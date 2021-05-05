# Monster

A pretty monster for theming GTK 2 and GTK 3 applications using the i3 window manager.

> **Note:** As the theme is made for i3 it might not look as good with other window managers.

## Requirements

- i3 window manager
- Terminal with support for RGB color code strings, eg. gnome-terminal
- a patched [nerd font](https://github.com/ryanoasis/nerd-fonts), set as font for the system and terminal.
- [feh image viewer](https://feh.finalrewind.org/)
- picom

## Install

To install the theme:

```
clone <repository>
ln -sf <repository-path>/compiled-theme/gtk ~/.themes/monster
mkdir -p ~/.config/term-themes
mkdir -p /root/.config/term-themes
ln -sf <repository-path>/compiled-theme/application-theme/terminal/ ~/.config/term-themes/monster
ln -sf <repository-path>/compiled-theme/application-theme/terminal/ /root/.config/term-themes/monster
mkdir -p ~/.config/feh
mkdir -p ~/.wallpapers
ln -sf <repository-path>/compiled-theme/application-themes/desktop/fehbg ~/.config/feh/fehbg
ln -sf <repository-path>/compiled-theme/application-themes/picom ~/.config/
```

add some image files in `~/.wallpapers/` and add the following to `~/.bashrc` and `/root/.bashrc`:

```
source ~/.config/term-themes/monster/file-theme.sh
source ~/.config/term-themes/monster/prompt-theme.sh
```

as well as the following to i3's `config` file:

```
exec_always --no-startup-id ~/.config/feh/fehbg
exec picom -b
```

Use something like `lxappearance` to select and activate the theme.

## Dependencies

If you want to make changes you'll need the following:

- `sassc`
- GTK dev package
  - `libgtk-3-dev` (debian)
  - `gtk3-devel` (fedora)
  - `gtk3` (arch)

If you want to test the theme you'll need a couple of GTK applications at least one GTK 2 and one GTK 3 application. For example:

- PCManFM (GTK 3)
- Double Commander (GTK 2)

## Development

### Application Windows

The color theme themes applications using:

- GTK 2.0
- GTK 3.0

#### GTK-2.0

For the gtk-2.0 theme there are two files of equal importance the `gtkrc` and `gtkrc.hidpi`. They are very similar and for the most part the `gtkrc.hidpi` only differs in larger sizes for higher dpi displays.

#### GTK-3.0

The gtk-3.0 theme uses the sass. Rules are defined in the `_*.scss` files and combined in the `main.scss` file. Try to keep all color definitions in the `_colors.scss` file.

To check what rules and selectors are used or available you can use [GTK inspector](https://wiki.gnome.org/Projects/GTK/Inspector). Enable the inspector in the terminal:

```
gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true
# or run the app with: GTK_DEBUG=interactive <start-app>
```

Focus the GTK application and press: `Control+Shift+D`.

> *Note:* Some applications binds `ctrl+shift+d` to other actions in which case you might need to try the `GTK_DEBUG` option.

It's not always clear what selectors will impact what elements. It may be helpful to use a finished theme (preferably quite minimalistic), change the colors, check what elements changes and what selector the color was used in. [AdMin](https://github.com/nrhodes91/AdMin) is a good choice to play around with. You may have to create a gtk-2.0 directory and `gtkrc` file for your theme chooser application (e.g. lxappearence) to find the theme, you may copy the gtk-2.0 directory of this repo.

### Terminal

We use the `LS_COLORS` environment variable to set the colors for file types in the terminal. We use RGB values in the color code strings, `38;2;RRR;BBB;GGG`, so make sure that your terminal emulator supports this.

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
