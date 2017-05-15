#!/usr/bin/env bash

#
# Install the packages given in the provided file.
# NOTE: Right now this script assumes you're using a Debian-based system.
# The packages file can have comments included using a hash character at the
# BEGINNING of the line.
#

[[ $# -ne 1 ]] && { >&2 echo "Usage: $0 <file with packages to install>"; exit 1; }

if  command -v apt-get &>/dev/null; then
	apt install $(grep -vE "^\s*#" $1  | tr "\n" " ")
# elif TODO: add other platforms
	# rpm/yum/pacman/brew etc
fi
