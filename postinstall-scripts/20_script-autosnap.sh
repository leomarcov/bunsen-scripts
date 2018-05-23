#!/bin/bash
# ACTION: Install script autosnap.sh (need Openbox config for autosnap with center clic in titlebar)
# INFO: Script autosnap.sh half-maximize windows in Openbox WM.
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

cp -v "$base_dir/autosnap-openbox/autosnap.sh" /usr/bin/
chmod +x /usr/bin/autosnap.sh
