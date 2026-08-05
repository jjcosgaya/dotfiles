# Dotfiles

Personal openSUSE/Wayland configuration managed with
[GNU Stow](https://www.gnu.org/software/stow/). Each directory is a package;
its contents mirror the layout under `~`.

## Packages

| Package | Contents |
| --- | --- |
| `bash`, `tmux`, `wezterm` | Shell, multiplexer, and terminal |
| `defaults` | Default applications and environment variables |
| `fuzzel`, `lsd`, `mako`, `waybar` | Wayland desktop and utilities |
| `power` | `power-profiles-daemon` helper and desktop controls |
| `gtk`, `niri`, `xdg-desktop-portal` | Theme and graphical session |
| `nvim`, `zathura` | Editor and PDF reader |
| `gnupg`, `pass` | GPG, `pinentry-smart`, and `pass` helpers |
| `pi` | Local Pi skills |
| `wallpapers` | Wallpaper |
| [`vimium`](vimium/README.md), [`userscripts`](userscripts/README.md) | Browser configuration and scripts |
| [`icons`](icons/README.md) | Themes, icons, and cursors (manual installation) |
| [`greetd`](greetd/README.md) | Display manager greeter and Kanagawa Dragon theme (manual installation) |

## Installation

```bash
sudo zypper install stow

git clone --branch opensuse-laptop \
  https://github.com/jjcosgaya/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow */
```

`stow */` links every package. Preview the changes first with:

```bash
stow -n -v */
```

Common operations:

```bash
stow niri        # link one package
stow -R niri     # relink it
stow -D niri     # unlink it
```

The links are symbolic, so editing `~/.config/...` or the corresponding file in
`~/.dotfiles` has the same effect.

## Package notes

- `defaults` configures Brave for HTML and web links, Neovim for text/code,
  Zathura for PDFs, and Thunar for folders. It also sets `EDITOR`, `VISUAL`,
  `GIT_EDITOR`, `SUDO_EDITOR`, `BROWSER`, and `TERMINAL`. Restart affected
  applications after changing these settings; graphical environment variables
  usually require logging out and back in.
- `pass-fuzzel` opens with `Mod+P` and copies passwords with `pass -c`.
  `Mod+U` copies the username. Requires `pass`, `fuzzel`, and `wl-clipboard`.
- `lock-screen` opens with `Mod+Shift+O`, captures the focused niri output,
  dims and blurs it, and uses it temporarily with `swaylock`. Requires niri
  26.04+, `swaylock`, and ImageMagick.
- `mako` manages notifications. Install it with
  `sudo zypper install mako`, then apply changes with `makoctl reload`.
- `power` provides the `power-profile` helper used by Waybar and niri. On
  this AMD laptop, use the native `power-profiles-daemon` service rather than
  stacking multiple power-management daemons:
  ```bash
  sudo zypper install power-profiles-daemon
  sudo systemctl unmask power-profiles-daemon.service
  sudo systemctl enable --now power-profiles-daemon.service
  ```
  Keep `tlp.service` and `tuned.service` stopped when using it. Check the
  available profiles and current profile with `powerprofilesctl list` and
  `powerprofilesctl get`. Waybar left-click/scroll cycles profiles, middle
  click selects `balanced`, right-click selects `power-saver`, and
  `Mod+Ctrl+P` cycles them from niri. Use
  `powerprofilesctl launch --profile performance -- <command>` for a
  one-off performance-sensitive command instead of leaving the whole system
  in performance mode.

  The AMD P-State driver is already active on this machine, so the daemon can
  control both CPU energy/performance preference and the ASUS platform profile.
  The optional AMD panel-saving action trades color accuracy for battery life;
  inspect it with `powerprofilesctl list-actions` and enable it only if that
  trade-off is acceptable:
  ```bash
  powerprofilesctl configure-action amdgpu_panel_power --enable
  ```
  The firmware already exposes a 75–80% battery charge threshold here, so no
  additional TLP or ASUS charge-limit setup is needed. TLP remains a possible
  alternative for fine-grained device policies, but it must not run alongside
  `power-profiles-daemon`.
- `gnupg` uses `pinentry-curses` in terminals and `pinentry-gnome3` in graphical
  applications. On openSUSE: `sudo zypper install pinentry-gnome3`, then run
  `gpgconf --reload gpg-agent` and open a new terminal.
- **Brave “login keyring” popup:** niri is launched by `greetd`, so GNOME Keyring
  is not unlocked automatically unless `greetd` is included in PAM. With
  `gnome-keyring-pam` installed, run:
  ```bash
  sudo /usr/sbin/pam-config --add \
    --gnome_keyring-only_if=gdm,gdm-password,lxdm,lightdm,mdm,sddm,login,greetd
  ```
  Then log out and back in. The existing `login` entry covers console logins;
  `greetd` is needed for this graphical session.
- Do not store caches, histories, sessions, or other automatically changing
  configuration here.

## Manual packages

These packages are ignored by Stow and installed manually:

- [Vimium](vimium/README.md)
- [YouTube userscript](userscripts/README.md)
- [Themes, icons, and cursors](icons/README.md)
- [greetd + tuigreet](greetd/README.md)

## Adding a package

```bash
mkdir -p ~/.dotfiles/myapp/.config
mv ~/.config/myapp ~/.dotfiles/myapp/.config/
cd ~/.dotfiles && stow myapp
```
