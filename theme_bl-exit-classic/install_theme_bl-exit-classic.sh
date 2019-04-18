#!/bin/bash
# ACTION: Config bl-exit window with the classic theme

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

sed  -i "s/^theme *= *.*/theme = classic/" /etc/bl-exit/bl-exitrc	
sed -i "s/^rcfile *= *.*/rcfile = none/" /etc/bl-exit/bl-exitrc
