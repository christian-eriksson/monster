# Monster

A pretty monster for theming a i3 window manager environment.

> **Note:** Monster includes themes for GTK 2 and GTK 3 applications, however As the theme is made for i3 it might not look as good with other window managers.

## Requirements

- a patched [nerd font](https://github.com/ryanoasis/nerd-fonts).
  - By default this i3 configuration uses:
    - NotoSans Nerd Font & NotoSans Nerd Font Mono for the i3bar
  - It also expects a Mono Nerd font as default font for the system and terminal, eg.:
    - DejaVuSansMono Nerd Font Mono
- [feh image viewer](https://feh.finalrewind.org/)
- i3 window manager, preferably [i3-gaps](https://github.com/Airblader/i3)
- [i3 blocks](https://vivien.github.io/i3blocks/)
- [pamixer](https://github.com/cdemoulins/pamixer), for i3blocks' volume script
- [SASS commandline tool](https://sass-lang.com/install)
- Terminal with support for RGB color code strings, eg. gnome-terminal
- The [Picom compositor](https://wiki.archlinux.org/title/Picom), it can be built from source [here](https://github.com/yshui/picom).
- [rofi](https://github.com/davatorium/rofi) version 1.6.1 or newer.

## Install

Prepare by creating a base config for i3, it should be a valid i3 config without commands to start fehbg and picom as well as the `bar{}` block, color and font settings. The partial config files in the [i3 directory](application-themes/i3/partial-configs) will be appended to this base config. If you wish to show more block device status entries in the status bar, create a i3blocks disk config file containing entries similar to home and root in [i3blocks.conf](application-themes/i3/i3blocks.conf)

To install the theme:

```
clone <repository>
./build.sh <home_dir> <base_i3_config_path> <network_interface_name> [<i3blocks_disk_config_path>]
ln -sf <repository-path>/compiled-theme/gtk ~/.themes/monster
ln -sf <repository-path>/compiled-theme/gtk/gtk-3.0/app-specific.css ~/.config/gtk-3.0/gtk.css
mkdir -p ~/.config/term-themes
mkdir -p /root/.config/term-themes
ln -sf <repository-path>/compiled-theme/application-theme/terminal/ ~/.config/term-themes/monster
ln -sf <repository-path>/compiled-theme/application-theme/terminal/ /root/.config/term-themes/monster
mkdir -p ~/.config/feh
mkdir -p ~/.wallpapers
ln -sf <repository-path>/compiled-theme/application-themes/desktop/fehbg ~/.config/feh/fehbg
ln -sf <repository-path>/compiled-theme/application-themes/picom ~/.config/
mkdir -p ~/.local/bin
ln -sf <repository-path>/compiled-theme/application-themes/i3/scripts ~/.local/bin/i3blocks
mkdir -p ~/.local/share/rofi/themes
ln -sf <repository-path>/compiled-theme/application-themes/rofi/monster.rasi ~/.local/share/rofi/themes
mkdir -p ~/.config/rofi
ln -sf <repository-path>/compiled-theme/application-themes/rofi/config.rasi ~/.config/rofi
mkdir -p ~/.config/i3
ln -sf <repository-path>/compiled-theme/application-themes/i3/i3blocks.conf ~/.config/i3/
ln -sf <repository-path>/compiled-theme/application-themes/i3/config ~/.config/i3/
./install-term-profile.sh
```

add some image files in `~/.wallpapers/` and add the following to `~/.bashrc` and `/root/.bashrc`:

```
source ~/.config/term-themes/monster/file-theme.sh
source ~/.config/term-themes/monster/prompt-theme.sh
```

Use something like `lxappearance` to select and activate the theme.

For the Firefox theme is published on [mozilla's addon store](https://addons.mozilla.org/en-US/firefox/addon/monster-theme/) and can be installed from there.

## Dependencies

If you want to make changes you'll need the following:

- The required dependencies listed above
- GTK dev package
  - `libgtk-3-dev` (debian)
  - `gtk3-devel` (fedora)
  - `gtk3` (arch)

If you want to test the theme you'll need a couple of GTK applications at least one GTK 2 and one GTK 3 application. For example:

- PCManFM (GTK 3)
- Double Commander (GTK 2)

## Development

### Application Windows

The color theme styles applications built on:

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

> _Note:_ Some applications binds `ctrl+shift+d` to other actions in which case you might need to try the `GTK_DEBUG` option.

It's not always clear what selectors will impact what elements. It may be helpful to use a finished theme (preferably quite minimalistic), change the colors, check what elements changes and what selector the color was used in. [AdMin](https://github.com/nrhodes91/AdMin) is a good choice to play around with. You may have to create a gtk-2.0 directory and `gtkrc` file for your theme chooser application (e.g. lxappearence) to find the theme, you may copy the gtk-2.0 directory of this repo.

### Terminal

We use the `LS_COLORS` environment variable to set the colors for file types in the terminal. We use RGB values in the color code strings, `38;2;RRR;BBB;GGG`, so make sure that your terminal emulator supports this.

### Firefox

To make changes to the firefox theme use the [Firefox Color Site](https://color.firefox.com/). If a previous version is loaded in Firefox you can start making changes. If not, transfer the values in the [manifest.json](application-themes/firefox/manifest.json) to the site manually.

Once you are happy with the new version export the theme, both the `*.zip` and `*.xpi`. Unpack the manifest from the zip and copy the manifest and `*.xpi` to the repository.

If you wish to publish the theme for yourself it has to go through Mozilla to be signed and possible to add to Firefox. Sign up for a [developer's account](https://addons.mozilla.org/en-US/developers/) and submit a theme for self distribution.

## Compile Theme

To compile the theme (if you have made changes):

```
cd <repository-path>
./build.sh <home_dir> <base_i3_config_path> <network_interface_name> [<i3blocks_disk_config_path>]
```

## Inspirations

The main inspirations for monster are:

- [Pacific-Blue Theme](https://www.gnome-look.org/p/1295782/)
  - The `gtkrc*` files for the GTK 2 part of the theme comes directly from this theme, though the colors have been modified to fit monster.
- [AdMin](https://github.com/nrhodes91/AdMin)
  - The way we organize scss files for the GTK 3 parts are inspired by this theme.
