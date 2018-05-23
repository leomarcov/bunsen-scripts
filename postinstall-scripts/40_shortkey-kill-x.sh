#!/bin/bash
# ACTION: Enable CTRL+ALT+BACKSPACE for kill X server
# DEFAULT: y

grep "terminate:ctrl_alt_bksp" /etc/default/keyboard &> /dev/null && exit

if grep "XKBOPTIONS" /etc/default/keyboard &>/dev/null; then
  sed -i "s/XKBOPTIONS=\"/XKBOPTIONS=\"terminate:ctrl_alt_bksp,/" /etc/default/keyboard  
else
  echo 'XKBOPTIONS="terminate:ctrl_alt_bksp"'>> /etc/default/keyboard
fi


