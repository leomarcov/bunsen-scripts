#!/bin/bash
# ACTION: Install script brightness.sh
# INFO: Script brightness.sh increase/decrease and set default brightness using xrandr.
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

cp -v "$base_dir"/brightness-control/brightness.sh /usr/bin/
chmod +x /usr/bin/brightness.sh

