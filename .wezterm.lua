local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "NotoMono Nerd Font"
})
config.harfbuzz_features = { "liga=0", "clig=0", "calt=0" } -- No ligatures
config.font_size = 14
config.color_scheme = 'Kanagawa (Gogh)'
-- config.color_scheme = 'Ashes (dark) (terminal.sexy)'
-- config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.9

config.colors = {
  background = '#1f201f',
}

-- config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false

return config
