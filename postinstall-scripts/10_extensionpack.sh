#!/bin/bash
# ACTION: Install VirtualBox Extension Pack
# DEFAULT: y

t=$(mktemp -d)
wget -P "$t" "$ep_url"  && \
yes | vboxmanage extpack install --replace "$t"/*extpack 
rm -rf "$t"
