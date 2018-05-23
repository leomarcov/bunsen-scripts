#!/bin/bash
# ACTION: Install script brightness.sh
# DESC: Script brightness.sh increase/decrease and set default brightness using xrandr.
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

cp -v "$basedir"/brightness-control/brightness.sh /usr/bin/
chmod +x /usr/bin/brightness.sh

