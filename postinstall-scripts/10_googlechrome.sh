#!/bin/bash
# ACTION: Install Google Chrome 
# DESC: Install Google chrome, config official repositories and set as default editor
# DEFAULT: y

# Install repositories
grep -R "dl.google.com" /etc/apt/ &> /dev/null || echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 

# Install package
apt-get update
apt-get install -y google-chrome-stable

# Set as default
update-alternatives --set x-www-browser /usr/bin/google-chrome-stable
update-alternatives --set gnome-www-browser /usr/bin/google-chrome-stable
