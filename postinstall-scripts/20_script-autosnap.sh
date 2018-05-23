#!/bin/bash
# ACTION: Install script autosnap.sh
# INFO: Script autosnap.sh autosnap windows (half-maximice) in Openbox WM.
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

cp -v "$base_dir/autosnap-openbox/autosnap.sh" /usr/bin/
chmod +x /usr/bin/autosnap.sh
