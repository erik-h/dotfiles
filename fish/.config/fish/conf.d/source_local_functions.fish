#
# Source all fish files in the `local_functions` directory.
# Functions located in $XDG_CONFIG_HOME/fish/conf.d/local_functions/ are
# ignored by git; they are intended to be _machine specific_ functions.
#
#
set -l local_functions_dir (dirname (status -f))"/local_functions"
for func in $local_functions_dir/*.fish
	source $func
end
