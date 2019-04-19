#!/bin/bash
# ACTION: Config first user account for autologin on tty1
# INFO: If you login on tty this option causes no need to enter user/password. The system start using the first user account automatically.
# DEFAULT: n

first_uid="$(grep "FIRST_UID=" /etc/adduser.conf | awk -F= '{print $2}')"
first_user="$(id -u "$first_uid" --name)"
if [ $? -ne 0 ]; then
	echo "Cant find the first user"
	exit 1
fi

echo "First user located: first_name"
[ ! -d /etc/systemd/system/getty\@tty1.service.d ] && mkdir -p /etc/systemd/system/getty\@tty1.service.d
echo '[Service]
ExecStart=
ExecStart=-/sbin/agetty -a '$first_user' --noclear %I $TERM' | tee /etc/systemd/system/getty\@tty1.service.d/autologin.conf
systemctl enable getty@tty1.service
