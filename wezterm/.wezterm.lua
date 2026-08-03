local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Same font chain as the rest of the system: monospace first, then
-- Noto Sans Symbols 2 (line-stroke symbols) before Font Awesome 7
-- (solid glyphs) — so the same Unicode character renders identically
-- in the nvim statusline, in fuzzel, and in the waybar modules.
config.font = wezterm.font_with_fallback({
    'Source Code Pro',
    'Noto Sans Symbols 2',
    'Font Awesome 7 Free',
})
config.font_size = 13
config.color_scheme = 'Kanagawa Dragon (Gogh)'

config.window_background_opacity = 0.9

config.enable_tab_bar = false

-- Use wl-paste directly; send_paste preserves bracketed paste.
local function paste_wayland(_, pane)
    local ok, text, err = wezterm.run_child_process({ 'wl-paste', '--no-newline' })
    if ok then
        pane:send_paste(text)
    else
        wezterm.log_error('wl-paste failed: ' .. tostring(err or 'unknown error'))
    end
end

config.keys = {
    {
        key = 'mapped:v',
        mods = 'CTRL|SHIFT',
        action = wezterm.action_callback(paste_wayland),
    },
    {
        key = 'mapped:v',
        mods = 'CTRL',
        action = wezterm.action_callback(paste_wayland),
    },
}

return config
