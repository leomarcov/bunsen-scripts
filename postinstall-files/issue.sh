#!/bin/bash
clear > /etc/issue
neofetch --config /usr/share/neofetch/config >> /etc/issue
echo -e "\e[1mUsers\e[0m: $(for u in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do if grep -Po '^sudo.+:\K.*$' /etc/group | grep -w "$u" &>/dev/null; then echo -en "\e[1m$u\e[0m  "; else echo -en "$u  "; fi; done)\n" >> /etc/issue
