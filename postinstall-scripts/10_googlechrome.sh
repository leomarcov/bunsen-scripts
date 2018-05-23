#!/bin/bash
# ACTION: Install Google Chrome 
# DESC: Install Google chrome, config official repositories and set as default editor
# DEFAULT: y

echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
apt-get update
apt-get install -y google-chrome-stable

update-alternatives --set x-www-browser /usr/bin/google-chrome-stable
update-alternatives --set gnome-www-browser /usr/bin/google-chrome-stable
