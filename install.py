#!/usr/bin/env python3

#
# Install the dotfiles in this directory using GNU Stow.
# NOTE: This script requires Python3.
#

# TODO: use `stow -t /etc etc` style and add another mode to this installer
# that works with system-wide files stowed relative to root.

import configparser
from glob import glob
import subprocess
import sys
import shutil
import os

# Put any non-dotfile containing directories to ignore in this list.
# TODO: once I have the install relative to root feature done, remove etc
# from this exclude list!
# TODO: come up with a way to automatically symlink userChrome.css...the trouble
# is that firefox profile names are different across machines.
EXCLUDE = ["PACKAGES", "etc", "userChrome.css"]
FIREFOX_DIR = os.path.expanduser("~/.mozilla/firefox")
FIREFOX_PROFILES_INI = os.path.join(FIREFOX_DIR, "profiles.ini")
if not os.path.exists(FIREFOX_PROFILES_INI):
    print("[WARN] Firefox profiles.ini doesn't exist at '{}'; skipping userChrome.css install...".format(FIREFOX_PROFILES_INI))
else:
    config = configparser.ConfigParser()
    config.read(FIREFOX_PROFILES_INI)

    valid_names = []
    print("Firefox profile names:")
    for i, section in enumerate(config.sections()):
        for key, value in config.items(section):
            if key == "name":
                print("{} -> {}".format(i, value))
                valid_names.append(section)

    profile_index = -1
    while profile_index not in range(1, len(valid_names)+1):
        profile_index = int(input("In which Firefox profile would you like to install 'userChrome.css'?: "))

    chosen_profile = valid_names[profile_index-1]
    print("Chose:", config[chosen_profile]["name"])
    chosen_profile_path = os.path.join(FIREFOX_DIR, config[chosen_profile]["path"])
    print("\tProfile path:", chosen_profile_path)
    # TODO: At this point we have the directory of their profile.
    # We should then:
    # - `mkdir -p` $THEDIRECTORY/chrome
    # - symlink the userChrome.css there

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
