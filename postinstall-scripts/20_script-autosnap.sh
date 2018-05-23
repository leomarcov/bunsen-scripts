#!/bin/bash
# ACTION: Install script autosnap.sh
# DESC: Script autosnap.sh autosnap windows (half-maximice) in Openbox WM.
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

cp -v "$basedir/autosnap-openbox/autosnap.sh" /usr/bin/
chmod +x /usr/bin/autosnap.sh
