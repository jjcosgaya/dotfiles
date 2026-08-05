# Handy

This Stow package installs Handy's desktop entry and icon. The AppImage itself
lives at `~/.local/bin/handy` and is not tracked here.

## Install Handy

```bash
mkdir -p ~/.local/bin
cp ~/Downloads/Handy*.AppImage ~/.local/bin/handy
chmod +x ~/.local/bin/handy
cd ~/.dotfiles && stow handy
sudo zypper install wtype
```

`wtype` lets Handy insert transcribed text in native Wayland applications.

## Enable the Wayland push-to-talk shortcut

Handy's default Tauri shortcut backend is unreliable under native Wayland. The
alternative **Handy Keys** backend reads keyboard events through Linux evdev,
so it receives both press and release events under niri and can provide real
push-to-talk.

Handy Keys needs access to the physical keyboard and `/dev/uinput`. The rules
below use systemd-logind `uaccess`, which grants access only to the active local
session instead of every login belonging to the `input` group.

Install the two tracked system files:

```bash
cd ~/.dotfiles/handy
sudo install -Dm644 system/70-handy-keys.rules \
  /etc/udev/rules.d/70-handy-keys.rules
sudo install -Dm644 system/handy-uinput.conf \
  /etc/modules-load.d/handy-uinput.conf

sudo udevadm control --reload-rules
sudo /usr/sbin/modprobe uinput
sudo udevadm trigger --action=change --subsystem-match=input --settle
sudo udevadm trigger --action=change --subsystem-match=misc \
  --sysname-match=uinput --settle
```

Verify that the current user can read at least one keyboard and write to
`uinput`:

```bash
find /dev/input -maxdepth 1 -name 'event*' -readable -print
[ -w /dev/uinput ] && echo '/dev/uinput is writable'
```

`Ctrl+Space` does not conflict with niri's `Mod+Space` binding, so no niri
binding change is required. If you changed niri's configuration while testing,
reload it with:

```bash
niri msg action load-config-file
```

Then configure Handy **in this order**:

1. Open **Settings → Advanced** and enable **Experimental Features**.
2. Under **Experimental**, change **Keyboard Implementation** to
   **Handy Keys**.
3. Only after switching to Handy Keys, set the transcription shortcut to
   `Ctrl+Space`. Trying to record shortcuts with the Tauri backend under native
   Wayland may capture only the modifier and reject them.
4. In **General**, enable **Push to Talk**.

Restart Handy if the backend does not begin working immediately. The log at
`~/.local/share/com.pais.handy/logs/handy.log` should contain
`handy-keys event` entries for both pressed and released states.

> **Security:** evdev access permits reading raw keyboard events, and uinput
> permits synthetic input. Handy Keys also grabs keyboards and reinjects
> non-shortcut events so the configured shortcut does not reach other apps.

## Revert the Wayland keyboard access

First change Handy's **Keyboard Implementation** back to
**Tauri Global Shortcut**, then quit Handy. Remove the system files and the ACL
entries they installed:

```bash
sudo rm -f \
  /etc/udev/rules.d/70-handy-keys.rules \
  /etc/modules-load.d/handy-uinput.conf
sudo udevadm control --reload-rules

sudo setfacl -x "u:$USER" /dev/uinput 2>/dev/null || true
for device in /dev/input/event*; do
  sudo setfacl -x "u:$USER" "$device" 2>/dev/null || true
done
```

Reboot to return the module and device permissions to their normal boot state.
For toggle mode without raw keyboard access, you may keep or restore niri's
`Mod+Space` binding and reload niri:

```bash
niri msg action load-config-file
```
