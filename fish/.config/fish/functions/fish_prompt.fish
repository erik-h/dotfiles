# Defined in /usr/share/fish/functions/fish_prompt.fish @ line 5
function fish_prompt --description 'Write out the prompt'
	set -l color_cwd
    set -l suffix
	set -l git_branch "("(git rev-parse --abbrev-ref HEAD 2> /dev/null)")"
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix (set_color red)'#'(set_color normal)
        case '*'
            set color_cwd $fish_color_cwd
            set suffix (set_color yellow)'$'(set_color normal)
    end

    echo -ens "$USER" (set_color green)@(set_color normal) (prompt_hostname) ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) " $git_branch" "\n$suffix "
end
