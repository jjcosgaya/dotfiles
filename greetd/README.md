# greetd + tuigreet

System-wide greetd configuration for niri with a monochrome Kanagawa Dragon
theme. This package is installed manually; Stow ignores it.

## Install

```bash
sudo zypper install greetd tuigreet

sudo install -D -m 0644 ~/.dotfiles/greetd/config.toml \
  /etc/greetd/config.toml
sudo install -D -m 0755 ~/.dotfiles/greetd/tuigreet-kanagawa.sh \
  /etc/greetd/tuigreet-kanagawa.sh
sudo install -d -o greeter -g greeter -m 0755 /var/cache/tuigreet

sudo systemctl enable greetd
sudo systemctl restart greetd
```

## Files

- `config.toml` → `/etc/greetd/config.toml`
- `tuigreet-kanagawa.sh` → `/etc/greetd/tuigreet-kanagawa.sh`

The wrapper sets the Linux VT palette and starts tuigreet with ANSI colors.

## Customize

Edit `tuigreet-kanagawa.sh`, then copy it again and restart greetd:

```bash
sudo install -m 0755 ~/.dotfiles/greetd/tuigreet-kanagawa.sh \
  /etc/greetd/tuigreet-kanagawa.sh
sudo systemctl restart greetd
```

- `--width` changes the box width.
- `--window-padding`, `--container-padding`, and `--prompt-padding` change
  its spacing and height.
- Upstream tuigreet renders F-key labels with reverse video; `button=darkgray`
  keeps that highlight subtle.
- The font is configured in `/etc/vconsole.conf`, not tuigreet. For example:

  ```bash
  sudo zypper install terminus-bitmap-fonts
  sudoedit /etc/vconsole.conf       # set FONT=ter-u16n
  sudo systemctl restart systemd-vconsole-setup
  ```

Check errors with:

```bash
journalctl -u greetd -b
```
