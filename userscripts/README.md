# Userscripts

Manual browser setup; Stow ignores the script and this README.

## YouTube speed control

Install [Violentmonkey](https://violentmonkey.github.io/) or Tampermonkey,
then create a script from `youtube-speed-control.user.js`.

- Arrow keys and mouse wheel: change speed by `0.1×`
- Middle mouse button: reset to `1×`
- `Shift`: use `0.25×` steps
- `[` and `]`: change speed

The selected speed persists between videos. Reload YouTube after saving
changes.

Copy the script to the clipboard on Wayland with:

```bash
wl-copy < youtube-speed-control.user.js
```
