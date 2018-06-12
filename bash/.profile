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

test -s "$HOME/.rvm/scripts/rvm" && . "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Setup Nix env
test -e "$HOME/.nix-profile/etc/profile.d/nix.sh" &&  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
