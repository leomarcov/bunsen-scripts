#!/bin/bash
# ACTION: Install Atom text editor
# DEFAULT: y

atom_url="https://atom.io/download/deb"
t=$(mktemp -d)
wget -P "$t" "$atom_url"  
if [ $? -eq 0 ]; then
  apt-get install gvfs-bin
  dpkg -i "$t/"*
fi 
rm -rf "$t"
