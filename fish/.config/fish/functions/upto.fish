function upto
	set EXPRESSION $argv[1]
	if [ -z "$EXPRESSION" ]
		echo "A folder expression must be provided." >&2
		return 1
	end
	if [ "$EXPRESSION" = "/" ]
		cd "/"
		return 0
	end
	set CURRENT_FOLDER (pwd)
	set MATCHED_DIR ""
	set MATCHING true

	while [ "$MATCHING" = true ]
		if echo $CURRENT_FOLDER | string match -r "$EXPRESSION" > /dev/null
			set MATCHED_DIR $CURRENT_FOLDER
			set CURRENT_FOLDER (dirname $CURRENT_FOLDER)
		else
			set MATCHING false
		end
	end
	if [ -n "$MATCHED_DIR" ]
		cd $MATCHED_DIR
		return 0
	else
		echo "No Match." >&2
		return 1
	end
end

#
# TODO: port this bash completion stuff over to fish
#
# # complete upto
# _upto () {
# 	# necessary locals for _init_completion
# 	local cur prev words cword
# 	_init_completion || return
# 
# 	COMPREPLY+=( $( compgen -W "$( echo ${PWD//\// } )" -- $cur ) )
# }
# # This complete scheme relies on bash_completion, and the subsequent
# # _init_completion function to work.
# declare -f _init_completion > /dev/null && complete -F _upto upto
