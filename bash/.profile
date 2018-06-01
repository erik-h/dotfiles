[ -n "$__PROFILE_IS_SET__" ] && { echo ".profile already set!"; return; }
export __PROFILE_IS_SET__="SET"

# If running bash, source its config files
if [ -n "$BASH_VERSION" ]; then
    [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi

# Set up our general environment variables
test -f "$HOME/.environ" && . "$HOME/.environ"

# If a .profile local to this machine exists, source it
test -f "$HOME/.local_profile" && . "$HOME/.local_profile"
