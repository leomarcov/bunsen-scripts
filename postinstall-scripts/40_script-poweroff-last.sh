#!/bin/bash
# ACTION: Install script poweroff_last.sh for automatize poweroff if no users logged in 20 minutes
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"
bash "$base_dir/other_scripts/poweroff_last.sh" -I 20
