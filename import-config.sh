#!/usr/bin/sh

dconf load /org/gnome/settings-daemon/plugins/media-keys/ < config/media_keys.ini
dconf load /org/gnome/desktop/wm/keybindings/ < config/wm_shortcuts.ini
dconf load /org/gnome/mutter/keybindings/ < config/mutter_shortcuts.ini

echo "Imported configurations!"
