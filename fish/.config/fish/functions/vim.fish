# Defined in /tmp/fish.OmgAV4/vim.fish @ line 2
function vim
	which nvim > /dev/null 2>&1; and nvim $argv; or command vim $argv
end
