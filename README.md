# GNOME Desktop Environment Configurations

Tracks keyboard shortcuts and GNOME Shell extensions (settings, enable state, and auto-install).

## Usage

### Export current configs to this repo
```bash
./export-config.sh
```

### Import configs to a new system
```bash
./import-config.sh
```

This will restore keyboard shortcuts and install any missing extensions from [extensions.gnome.org](https://extensions.gnome.org) (compatible with your GNOME Shell version). Extensions not found on e.g.o are skipped with a warning — install those manually.

**Dependencies:** `jq`, `curl`

**Note:** After importing, log out and back in (or Alt+F2 → `r` → Enter) for new extensions to load.
