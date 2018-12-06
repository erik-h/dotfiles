#!/usr/bin/env python3

#
# Install the dotfiles in this directory using GNU Stow.
# NOTE: This script requires Python3.
#

# TODO: maybe don't issue a warning on installing user{Chrome,Content}.css?
# It's fairly verbose every time I install a new dotfile. Another option is to
# have a flag that enable or disables installing user{Chrome,Content}.css.

# TODO: use `stow -t /etc etc` style and add another mode to this installer
# that works with system-wide files stowed relative to root.

# TODO: add some auto-generation of some dynamic configs such as:
# - ~/.gnupg/gpg-agent.conf -> as of now this would just be:
# `mkdir -p ~/.gnupg && echo "pinentry-program $HOME/bin/smart-pinentry" >> ~/.gnupg/gpg-agent.conf`

import configparser
from glob import glob
import subprocess
import sys
import shutil
import os
import errno

# Put any non-dotfile containing directories to ignore in this list.
# TODO: once I have the install relative to root feature done, remove etc
# from this exclude list!
EXCLUDE = ["PACKAGES", "etc", "userChrome.css", "userContent.css"]
FIREFOX_DIR = os.path.expanduser("~/.mozilla/firefox")
FIREFOX_PROFILES_INI = os.path.join(FIREFOX_DIR, "profiles.ini")
SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

# Create a symlink for the given source, relative to _this_ dotfiles repo's
# location, to the given destination directory.
# e.g. symlink_in_dir("foo/bar.txt", "/tmp/) creates the following link:
# /tmp/foo -> <this dotfiles repo>/foo/bar.txt
def symlink_in_dir(src, dst):
    src_path = os.path.join(SCRIPT_DIR, src)
    dst_path = os.path.join(dst, src)
    try:
        os.symlink(src_path, dst_path)
    except OSError as e:
        # If our link name already exists, try removing it and trying again
        if e.errno == errno.EEXIST:
            print(
                "[WARN] '{}' already exists at '{}'; it will be OVERWRITTEN."
                    .format(src, dst)
            )
            os.remove(dst_path)
            os.symlink(src_path, dst_path)
        else:
            raise e

def main():
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
            profile_index = int(input("In which Firefox profile would you like to install 'userChrome.css' and 'userContent.css'?: "))

        chosen_profile = valid_names[profile_index-1]
        print("Chose:", config[chosen_profile]["name"])
        chosen_profile_path = os.path.join(FIREFOX_DIR, config[chosen_profile]["path"])
        print("\tProfile path:", chosen_profile_path)
        # user{Chrome,Content}.css should be installed in $FIREFOX_PROFILE/chrome
        chrome_path = os.path.join(chosen_profile_path, "chrome")
        os.makedirs(chrome_path, exist_ok=True)
        symlink_in_dir("userChrome.css", chrome_path)
        symlink_in_dir("userContent.css", chrome_path)

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

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nCaught SIGINT; stopping...")
