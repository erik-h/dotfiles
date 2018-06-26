# Combine i3 configs together based on our hostname; I vary my i3 configuration
# between machines.
# Note: `mkconfig` is a soon-to-be open sourced Ruby script for adding
# C-style #include functionality into arbitrary files.
"$HOME/bin/mkconfig" -o "$HOME/.i3/config" "$HOME/.i3/$(hostname).i3config"
exec i3
