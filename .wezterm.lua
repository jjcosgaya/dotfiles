local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 14
config.color_scheme = 'Kanagawa (Gogh)'
-- config.color_scheme = 'Ashes (dark) (terminal.sexy)'
-- config.color_scheme = 'Catppuccin Mocha'

-- config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false

return config
