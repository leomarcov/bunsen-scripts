#!/bin/bash
# ACTION: Install clear xfce4-notify theme
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

# Create theme:
mkdir -p "/usr/share/themes/clear-notify/xfce-notify-4.0/"
cp -v "$base_dir/postinstall-files/clear_xfce-notify-4.0_gtk.css" "/usr/share/themes/clear-notify/xfce-notify-4.0/gtk.css"

for f in  /usr/share/bunsen/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml  /home/*/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml ; do
  sed -i '/name="theme"/s/value=".*"/value="clear-notify"/' "$f"
done

