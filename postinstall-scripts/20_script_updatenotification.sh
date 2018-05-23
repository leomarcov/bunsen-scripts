
#!/bin/bash
# ACTION: Install script update-notification.sh
# DESC: Script update-notification.sh checks periodically APT updates and show in tint2 bar
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

bash "$base_dir/update-notification-tint/update-notification.sh" -I 
