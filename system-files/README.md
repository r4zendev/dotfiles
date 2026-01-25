# System Files

Files in this directory need to be installed to system locations (outside of home directory) and require root/sudo access.

## Installation

These files are automatically installed by the `bin/install-arch.sh` script.

To manually install:

```bash
# KDE/Dolphin service menus
sudo cp system-files/kio-servicemenus/admin-folder.desktop /usr/share/kio/servicemenus/
sudo chmod 644 /usr/share/kio/servicemenus/admin-folder.desktop
kbuildsycoca6  # rebuild KDE service cache
```

## Contents

- `kio-servicemenus/admin-folder.desktop` - Adds "Open as Administrator" context menu to Dolphin file manager

## Related Configs

The following user configs work together with system files:

- `stow/linux/.config/mimeapps.list` - Default applications for file types (symlinked via stow)
