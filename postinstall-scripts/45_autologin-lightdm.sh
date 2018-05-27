#!/bin/bash
# ACTION: Config first user account for autologin on lightdm
# INFO: If you login on lightdm this option causes no need to enter user/password. The system start using the first user account automatically.
# DEFAULT: n

first_uid="$(grep "FIRST_UID=" /etc/adduser.conf | awk -F= '{print $2}')"
first_user="$(id -u "$first_uid" --name)"
if [ $? -ne 0 ]; then
	echo "Cant find the first user"
	exit 1
fi

echo "First user located: first_name"
echo '[SeatDefaults]
autologin-user='"$first_user"'
autologin-user-timeout=0' | tee /etc/lightdm/lightdm.conf
