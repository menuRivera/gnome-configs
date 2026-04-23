#!/usr/bin/sh

dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > config/media_keys.ini
dconf dump /org/gnome/desktop/wm/keybindings/ > config/wm_shortcuts.ini
dconf dump /org/gnome/mutter/keybindings/ > config/mutter_shortcuts.ini

echo "Done!"
