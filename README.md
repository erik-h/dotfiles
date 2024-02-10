Dotfiles
========

These are some of the files that I use to configure my *nix environments.

## Installation
[GNU Stow](https://www.gnu.org/software/stow/) is used to manage these dotfiles.

The script `install.py` can be used to run `stow` on all directories that are not
in its hardcoded exclude list. Note that it requires `python3` to be installed.

## Packages
The `./PACKAGES/` directory included in my exclude list contains text files with
package names. These files are intended to be passed as an argument to `pkg-install.sh`,
which will install all of the packages. Lines beginning with a hash will be
treated as comments and ignored.
