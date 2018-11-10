#!/bin/sh

# null internal field separator to make handling newlines easier
IFS=

# Store directory of this file in $dir
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

update_file() {
  outpath=$1
  newlist=$2

  fqoutpath=$dir/$1

  if echo $newcontents | diff $fqoutpath - &>/dev/null; then
    echo "$outpath haven't changed"
  else
    echo $newcontents > $fqoutpath
    echo "Updated $1"
  fi
}

# Arch Linux packages
if [ -f "/etc/arch-release" ]; then
  update_file archlinux/packages $(pacman -Qeq)
else
  echo "Not running Arch Linux"
fi

# Visual Studio Code
codepath=$(which code)
case "$OSTYPE" in
  linux*)
    settingspath=$HOME/.config/Code/User/settings.json
    ;;
  msys*)
    settingspath=$APPDATA/Code/User/settings.json
    ;;
esac

if [[ -f $codepath ]]; then
  # Extensions
  update_file vscode/extensions $(code --list-extensions)
  
  # Settings file
  update_file vscode/settings.json $(cat $settingslist)
else
  echo "VSCode not installed or not on \$PATH"
fi


