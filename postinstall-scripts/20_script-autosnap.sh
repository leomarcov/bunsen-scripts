#!/bin/bash
# ACTION: Install script autosnap.sh for autosnap windows with center click in titlebar
# INFO: Script autosnap.sh half-maximize windows in Openbox WM.
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

cp -v "$base_dir/autosnap-openbox/autosnap.sh" /usr/bin/
chmod +x /usr/bin/autosnap.sh

for d in /usr/share/bunsen/skel/.config/  /home/*/.config/; do
  # Copy rc.xml config with shortkeys for autosnap
	cp -v "$base_dir/postinstall-files/rc.xml" "$d/openbox/"
done
