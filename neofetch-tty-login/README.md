# Neofetch TTY login message
Shows a message in tty using neofetch


## Install
```bash
cp -v /etc/issue /etc/issue.old
[ ! -d "/etc/systemd/system/getty@.service.d/" ] && mkdir -vp "/etc/systemd/system/getty@.service.d/"
[ ! -d "/usr/share/neofetch/" ] && mkdir -vp "/usr/share/neofetch/"
cp -v ./config_tty /usr/share/neofetch/
cp -v ./neofetch-issue.sh /usr/bin/
chmod -v a+x /usr/bin/neofetch-issue.sh

echo '[Service]
ExecStartPre=-/bin/bash -c "/usr/bin/neofetch-issue.sh"' | tee "/etc/systemd/system/getty@.service.d/override.conf"

```
