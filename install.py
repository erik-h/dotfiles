#!/usr/bin/env python3

#
# Install the dotfiles in this directory using GNU Stow.
# NOTE: This scripts requires Python3.
#

# TODO: use `stow -t /etc etc` style and add another mode to this installer
# that works with system-wide files stowed relative to root.

from glob import glob
import subprocess
import sys
import shutil
import os

# Put any non-dotfile containing directories to ignore in this list.
# TODO: once I have the install relative to root feature done, remove etc
# from this exclude list!
EXCLUDE = ["PACKAGES", "etc"]

# Ensure GNU Stow is installed, as it is the program we use to install our dotfiles
if shutil.which("stow") is None:
    print("[ERROR] GNU Stow is required to install these dotfiles (https://www.gnu.org/software/stow/).", file=sys.stderr)
    sys.exit(1)

# Each directory alongside this script contains dotfiles
for target in glob("./*/"):
    # We use normpath because Stow wants just the directory name with no
    # leading "./" or trailing "/".
    target = os.path.normpath(target)
    if target not in EXCLUDE:
        print("Installing", target)
        subprocess.call(["stow", target])

print("Done!")
