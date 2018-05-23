#!/bin/bash
# ACTION: Enable CTRL+ALT+BACKSPACE for kill X server
# DEFAULT: y

sed -i "/XKBOPTIONS/Id" /etc/default/keyboard
echo 'XKBOPTIONS="terminate:ctrl_alt_bksp"'>> /etc/default/keyboard
