local wezterm = require 'wezterm'
local config = wezterm.config_builder()

function file_exists(name)
	return next(wezterm.glob(name)) ~= nil
end

config.audible_bell = "Disabled"

config.color_scheme = 'Dracula'

if file_exists('/opt/homebrew/bin/fish') then
	config.default_prog = { '/opt/homebrew/bin/fish', '-l', '-c', '/opt/homebrew/bin/tmux' }
elseif file_exists('/usr/bin/fish') then
	config.default_prog = { '/usr/bin/fish', '-l', '-c', '/usr/bin/tmux' }
end

-- Don't use the tab bar; I'll use tmux windows
config.enable_tab_bar = false

config.font_size = 14.0

config.keys = {
	{
		mods = 'CTRL',
		key = '0',
		action = wezterm.action.ResetFontSize
	}
}

-- Use machine-specific local config overrides if they exist
local local_config_exists, local_config = pcall(require, "local")
if (local_config_exists) then
	for k, v in pairs(local_config) do
		config[k] = v
	end
end

return config
