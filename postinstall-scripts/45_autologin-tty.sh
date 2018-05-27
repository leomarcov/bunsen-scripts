#!/bin/bash
# ACTION: Config first user account for autologin on tty1
# INFO: If you login on tty this option causes no need to login on tt1 for the first user on the system
# DEFAULT: y

first_uid="$(grep "FIRST_UID=" /etc/adduser.conf | awk -F= '{print $2}')"
first_user="$(id -u "$first_uid" --name)"

if [ $? -ne 0 ]; then
	echo "Cant find the first user"
	exit 1
fi

[ ! -d etc/systemd/system/getty\@tty1.service.d ] && mkdir -p etc/systemd/system/getty\@tty1.service.d
[Service]
ExecStart=
ExecStart=-/sbin/agetty -a '$first_user' %I $TERM'
