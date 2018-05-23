#!/bin/bash
# ACTION: Install and set for all users openbox theme
# DESC: GoHome modified is a clear and cool Openbox theme.
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

unzip -o "$basedir"/postinstall-files/openbox_themes.zip -d /usr/share/themes/
for d in  /usr/share/bunsen/skel/.config/openbox/  /home/*/.config/openbox/ ; do
	cp -v "$basedir/postinstall-files/rc.xml" "$d"
done
