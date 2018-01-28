#!/usr/bin/env bash

#
# Install the packages given in the provided file.
# NOTE: Right now this script assumes you're using a Debian-based system.
# The packages file can have comments included using a hash character at the
# BEGINNING of the line.
#

function usage() {
	>&2 echo "Usage: $0 [options] <file with packages to install>"
	>&2 echo -e "\nOptions:"
	>&2 echo -e "-g\tinstall packages globally (instead of for the local user)"
}

# Return 0 if a package _is_ installed, otherwise 1.
function ensure_installed() {
	command -v "$1" &>/dev/null || { >&2 echo "[FATAL] $1 not installed!"; return 1; }
	return 0
}

# Remove the commented lines from the packages file (lines that start with '#').
function remove_comments() {
	grep -vE "^\s*#" "$1"  | tr '\n' ' '
}

[[ $# -eq 0 ]] && { usage; exit 1; }

global=false
# Parse our command line args
while getopts "h?g" opt; do
	case "$opt" in
		h|\?)
			echo
			usage
			exit 1
			;;
		g)
			global=true
			;;
	esac
done

shift $(($OPTIND - 1))

pkg_file="$1"
pkg_file_base="$(basename "$pkg_file")"

if [[ "$global" == true ]]; then
	echo "[INFO] installing globally."
	# Ensure we're root
	if [[ $EUID -ne 0 ]]; then
		>&2 echo "[FATAL] global install requires running this script as root."
		exit 1
	fi
else
	echo "[INFO] installing locally."
fi

# Determine what kind of package file we're dealing with, then install its packages.
case "$pkg_file_base" in
	apt*)
		echo "[INFO] apt package file detected."
		ensure_installed "apt" || exit 1
		# Warn the user that apt packages must be installed globally
		[[ "$global" == false ]] && echo "[WARN] apt has no local option!"

		apt install $(remove_comments $pkg_file)
		;;
	pip3*)
		echo "[INFO] pip package file detected."
		ensure_installed "pip3" || exit 1

		if [[ "$global" == true ]]; then
			pip3 install -r "$pkg_file"
		else
			pip3 install --user -r "$pkg_file"
		fi
		;;
	trizen*)
		echo "[INFO] arch (trizen) package file detected."
		ensure_installed "trizen" || exit 1

		trizen -S $(remove_comments $pkg_file)
		;;
	*)
		# TODO: add other platforms; rpm, yum, pacman, brew, etc
		>&2 echo "[FATAL] unrecognized package file: $pkg_file_base"
		exit 1
		;;
esac
