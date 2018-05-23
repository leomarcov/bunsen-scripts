#!/bin/bash
# ACTION: Install Numix-Paper icon theme and set as default for all users
# DESC: Numix-Paper is a icon theme based on Numix and Paper icon themes.
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

[ ! -d /usr/share/fonts/extra ] && mkdir /usr/share/fonts/extra/
unzip -o "$basedir"/postinstall-files/fonts.zip -d /usr/share/fonts/extra/
