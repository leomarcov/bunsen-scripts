#!/bin/bash
# ACTION: Install Sublime Text, add repositories and set as default editor 
# DEFAULT: y

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
apt-get update
if apt-get install sublime-text; then
	update-alternatives --install /usr/bin/bl-text-editor bl-text-editor /usr/bin/subl 90 && \
	update-alternatives --set bl-text-editor /usr/bin/subl
fi
