#!/bin/bash
# ACTION: Config bl-exit window with the classic theme

sed  -i "s/^theme *= *.*/theme = classic/" /etc/bl-exit/bl-exitrc	
sed -i "s/^rcfile *= *.*/rcfile = none/" /etc/bl-exit/bl-exitrc
