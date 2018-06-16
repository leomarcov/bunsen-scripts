#!/bin/bash
# ACTION: Install Atom text editor
# DEFAULT: y

atom_url="https://atom.io/download/deb"
t=$(mktemp -d)
wget -P "$t" "$atom_url"  
[ $? -eq 0 ] | dpkg -i "$t/*"
rm -rf "$t"
