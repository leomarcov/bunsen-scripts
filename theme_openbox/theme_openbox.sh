#!/bin/bash
# ACTION: Install theme GoHome for Openbox and set as default for all users
# INFO: GoHome modified is a clear and cool Openbox theme.
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

base_dir="$(dirname "$(readlink -f "$0")")"

# Copy theme
unzip -o "$base_dir"/openbox_theme.zip -d /usr/share/themes/

# Config theme as default for all users
for f in  /usr/share/bunsen/skel/.config/openbox/rc.xml  /home/*/.config/openbox/rc.xml ; do
	rc="$(sed '/<theme>/q' "$f"; cat "$base_dir/theme_rc.xml"; sed -n -e '/<\/theme>/,$p' "$f")"
	echo "$rc" > "$f"
done
