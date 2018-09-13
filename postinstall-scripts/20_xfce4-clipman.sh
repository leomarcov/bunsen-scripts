
#!/bin/bash
# ACTION: Replace clipit for xfce4-clipman (allow screenshot to clipboard)
# DEFAULT: y

apt-get install xfce4-clipman
apt-get remove clipit

for d in /usr/share/bunsen/skel/.config/openbox/autostart  /home/*/.config/openbox/autostart; do

done
