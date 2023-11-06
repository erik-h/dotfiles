local wezterm = require 'wezterm'
local config = wezterm.config_builder()

function file_exists(name)
	return next(wezterm.glob(name)) ~= nil
end

config.color_scheme = 'Dracula'

if file_exists('/opt/homebrew/bin/fish') then
	config.default_prog = { '/opt/homebrew/bin/fish', '-l', '-c', '/opt/homebrew/bin/tmux' }
elseif file_exists('/usr/bin/fish') then
	config.default_prog = { '/usr/bin/fish', '-l', '-c', '/usr/bin/tmux' }
end

-- Don't use the tab bar; I'll use tmux windows
config.enable_tab_bar = false

config.font_size = 11.0

return config
