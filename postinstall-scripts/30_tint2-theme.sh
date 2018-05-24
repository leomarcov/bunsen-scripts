#!/bin/bash
# ACTION: Install new tint2 theme
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

# Check if laptop:
[ -f /sys/module/battery/initstate ] || [ -d /proc/acpi/battery/BAT0 ] && laptop="true"
# Check if virtualmachine:
cat /proc/cpuinfo | grep -i hypervisor &>/dev/null && virtualmachine="true"

for d in /usr/share/bunsen/skel/.config/tint2/  /home/*/.config/tint2/; do
	[ ! -f "$d/tint2rc_bunsen" ] && cp -v "$d/tint2rc" "$d/tint2rc_bunsen"
	
	[ "$laptop" ] && [ ! "$virtualmachine" ] && tint_laptop="_laptop"
	cp -v "$base_dir"/postinstall-files/tint2rc${tint_laptop} "$d/tint2rc"
	
	[ "${d:1:4}" = "home" ] && echo "$d/tint2rc" > "$d/tint2-sessionfile"
done
