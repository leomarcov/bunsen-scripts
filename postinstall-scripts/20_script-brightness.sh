#!/bin/bash
# ACTION: Install script brightness.sh
# INFO: Script brightness.sh increase/decrease and set default brightness.
# DEFAULT: y

base_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"
bash "$base_dir/brightness-control/brightness.sh" -I 
