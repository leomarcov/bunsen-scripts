#!/bin/bash
# ACTION: Install VirtualBox Extension Pack
# DEFAULT: y

# Get last EP URL from: https://www.virtualbox.org/wiki/Downloads
ep_url="https://download.virtualbox.org/virtualbox/6.0.4/Oracle_VM_VirtualBox_Extension_Pack-6.0.4.vbox-extpack"   

if ! which vboxmanage &> /dev/null; then
  echo "$(basename $0): VirtualBox is not installed"
  exit 1
fi

t=$(mktemp -d)
wget -P "$t" "$ep_url"  
[ $? -eq 0 ] && yes | vboxmanage extpack install --replace "$t"/*extpack 
rm -rf "$t"
