#!/usr/bin/sh

dconf load /org/gnome/settings-daemon/plugins/media-keys/ < config/media_keys.ini
dconf load /org/gnome/desktop/wm/keybindings/ < config/wm_shortcuts.ini
dconf load /org/gnome/mutter/keybindings/ < config/mutter_shortcuts.ini

if [ -f config/extensions/manifest.json ]; then
    mkdir -p config/extensions
    shell_version=$(gnome-shell --version | sed 's/[^0-9]*\([0-9]*\).*/\1/')

    for row in $(jq -c '.[]' config/extensions/manifest.json); do
        uuid=$(echo "$row" | jq -r '.uuid')
        name=$(echo "$row" | jq -r '.name')
        state=$(echo "$row" | jq -r '.state')

        if ! gnome-extensions info "$uuid" >/dev/null 2>&1; then
            echo "Installing $name ($uuid)..."
            api_json=$(curl -s "https://extensions.gnome.org/extension-info/?uuid=$uuid")
            compatible=$(echo "$api_json" | jq --arg v "$shell_version" \
                '.shell_version_map | has($v)' 2>/dev/null)

            if [ "$compatible" = "true" ]; then
                encoded_uuid=$(echo "$uuid" | jq -sRr '@uri')
                dl_url="https://extensions.gnome.org/download-extension/${encoded_uuid}.shell-extension.zip?shell-version=$shell_version"
                curl -sL -o "/tmp/$uuid.zip" "$dl_url" && \
                gnome-extensions install "/tmp/$uuid.zip" && \
                rm -f "/tmp/$uuid.zip" && \
                echo "  Installed" || \
                echo "  Failed to install"
            elif [ "$compatible" = "false" ]; then
                echo "  Not compatible with GNOME Shell $shell_version. Skipping."
            else
                echo "  Not found on e.g.o. Install manually."
            fi
        fi

        ini_file="config/extensions/$uuid.ini"
        if [ -f "$ini_file" ] && [ -s "$ini_file" ]; then
            dconf load "/org/gnome/shell/extensions/$uuid/" < "$ini_file"
        fi

        if [ "$state" = "ENABLED" ]; then
            gnome-extensions enable "$uuid" 2>/dev/null
        else
            gnome-extensions disable "$uuid" 2>/dev/null
        fi
    done
fi

echo "Imported configurations!"
