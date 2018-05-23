#!/bin/bash
# ACTION: Set default brightness when start Openbox
# INFO: Default brightness can be configured in brightness.sh
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

! which brightness.sh &> /dev/null && bash "$base_dir/postinstall-scripts/*script-brightness.sh"

for f in  /usr/share/bunsen/skel/.config/openbox/autostart  /home/*/.config/openbox/autostart; do
		sed -i "/brightness.sh -def/Id" "$d/.bashrc" 2> /dev/null
		echo "brightness.sh -def &" >> "$f"
done
