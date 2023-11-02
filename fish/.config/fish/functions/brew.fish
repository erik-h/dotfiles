function brew --description 'Run brew bundle dump whenever I {un,}install things with brew'
	set dump_commands "install" "uninstall"
	set issued_command $argv[1]

	command brew $argv

	if test $status -eq 0
		for dump in $dump_commands
			if test $issued_command = $dump
				command brew bundle dump --file="$HOME/.dotfiles/brew/Brewfile" --force
			end
		end
	end
end
