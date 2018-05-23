
#!/bin/bash
# ACTION: Install script update-notification.sh
# DESC: Install script update-notification.sh
# DEFAULT: y

basedir="$(dirname "$(dirname "$(readlink -f "$0")")")"

bash "$base_dir/update-notification-tint/update-notification.sh" -I 
