local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Dracula'

-- Use fish and tmux
config.default_prog = { '/usr/bin/fish', '-l', '-c', 'tmux' }

-- Don't use the tab bar; I'll use tmux windows
config.enable_tab_bar = false

config.font_size = 11.0

return config
