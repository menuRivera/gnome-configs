#!/usr/bin/sh

dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > config/media_keys.ini
dconf dump /org/gnome/desktop/wm/keybindings/ > config/wm_shortcuts.ini
dconf dump /org/gnome/mutter/keybindings/ > config/mutter_shortcuts.ini

mkdir -p config/extensions

enabled_uuids=$(gnome-extensions list --enabled 2>/dev/null)
manifest='[]'

for uuid in $(gnome-extensions list --user 2>/dev/null); do
    ini_file="config/extensions/$uuid.ini"
    dconf dump "/org/gnome/shell/extensions/$uuid/" > "$ini_file"
    [ ! -s "$ini_file" ] && rm -f "$ini_file"

    state="DISABLED"
    for e in $enabled_uuids; do
        [ "$e" = "$uuid" ] && state="ENABLED" && break
    done

    name=$(gnome-extensions info "$uuid" 2>/dev/null | sed -n 's/^Name: *//p')

    manifest=$(echo "$manifest" | jq \
        --arg uuid "$uuid" \
        --arg name "${name:-$uuid}" \
        --arg state "$state" \
        '. + [{"uuid": $uuid, "name": $name, "state": $state}]')
done

echo "$manifest" > config/extensions/manifest.json
echo "Done!"
