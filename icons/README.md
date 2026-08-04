# Themes, icons, and cursors

`../desktop-assets.tar.gz` contains:

- **Graphite-Dark** GTK theme
- **FairyWren** icons
- **Bibata Modern Ice** cursors
- Theme source instructions and patch

Run these commands from the dotfiles directory:

```bash
cd ~/.dotfiles
mkdir -p /tmp/assets ~/.local/share/themes ~/.local/share/icons ~/.icons
tar -xzf desktop-assets.tar.gz -C /tmp/assets

cp -r /tmp/assets/theme/Graphite-Dark ~/.local/share/themes/
cp -r /tmp/assets/icons/FairyWren ~/.icons/
cp -r /tmp/assets/cursor/Bibata-Modern-Ice ~/.local/share/icons/
ln -sfn ~/.local/share/icons/Bibata-Modern-Ice ~/.icons/Bibata-Modern-Ice
gtk-update-icon-cache ~/.icons/FairyWren
rm -rf /tmp/assets
```

The cursor link in `~/.icons` is required by niri. Change the FairyWren folder
color with:

```bash
ln -sfn <color> ~/.icons/FairyWren/places/colours/default
gtk-update-icon-cache ~/.icons/FairyWren
```

List available colors:

```bash
ls ~/.icons/FairyWren/places/colours/
```

For rebuilding the GTK theme, see `INSTALL.md` inside the archive;
`sassc` is required. The included patch preserves the dark Kanagawa Dragon
background and fixes text in sidebars, Thunar, and GTK3 menu accelerators.
