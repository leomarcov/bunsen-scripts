#!/bin/bash
# ACTION: Install script autosnap for autosnap windows with center click in titlebar
# INFO: Script autosnap half-maximize windows in Openbox WM.
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

base_dir="$(dirname "$(readlink -f "$0")")"
comment_mark="#BL-POSTINSTALL-autosnap"

cp -v "$base_dir/autosnap" /usr/bin/
chmod +x /usr/bin/autosnap

for f in /usr/share/bunsen/skel/.config/openbox/rc.xml  /home/*/.config/openbox/rc.xml; do
	# Delete all previous lines added
	sed -i "/${comment_mark}/Id" "$f"

	# Add keybinds por each autosnap command
	rc="$(sed '/<keyboard>/q' "$f"; cat "$base_dir/keybinds_rc.xml"; sed -n -e '/<keyboard>/,$p' "$f" | tail +2 )"
	echo "$rc" > "$f"

	# Delete current mousebind center click
	sed -i "/<item label=\"Run Program\">/,/<\/item>/d" "$f"

	# Add mousebind center click
	rc="$(sed '/<context name="Titlebar">/q' "$f"; cat "$base_dir/mousebind_rc.xml"; sed -n -e '/<context name="Titlebar">/,$p' "$f" | tail +2)"
	echo "$rc" > "$f"
done
