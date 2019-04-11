#!/bin/bash
# ACTION: Remove bunsen-welcome autostart script 
# DEFAULT: y

apt-get remove bunsen-welcome

for f in /usr/share/bunsen/skel/.config/openbox/autostart  /home/*/.config/openbox/autostart; do
    sed -i "/bl-welcome/ s/^#*/#/" "$f"
done
