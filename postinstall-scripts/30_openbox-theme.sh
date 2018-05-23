#!/bin/bash
# ACTION: Install GoHome Openbox theme and set as default for all users
# INFO: GoHome modified is a clear and cool Openbox theme.
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

unzip -o "$base_dir"/postinstall-files/openbox_themes.zip -d /usr/share/themes/
for d in  /usr/share/bunsen/skel/.config/openbox/  /home/*/.config/openbox/ ; do
	cp -v "$base_dir/postinstall-files/rc.xml" "$d"
done
