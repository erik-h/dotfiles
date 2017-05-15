#!/usr/bin/env python3

#
# Install the dotfiles in this directory using GNU Stow.
# NOTE: This scripts requires Python3.
#

from glob import glob
import subprocess
import sys
import shutil
import os

# Put any non-dotfile containing directories to ignore in this list.
EXCLUDE = ["./packages/"]

# Ensure GNU Stow is installed, as it is the program we use to install our dotfiles
if shutil.which("stow") is None:
    print("[ERROR] GNU Stow is required to install these dotfiles (https://www.gnu.org/software/stow/).", file=sys.stderr)
    sys.exit(1)

# Each directory alongside this script contains dotfiles
for target in glob("./*/"):
    if target not in EXCLUDE:
        print("Installing", target)
        # We use normpath because Stow wants just the directory name with no
        # leading "./" or trailing "/".
        subprocess.call(["stow", os.path.normpath(target)])
print("Done!")
