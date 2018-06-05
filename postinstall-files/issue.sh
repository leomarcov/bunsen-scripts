#!/bin/bash
clear > /etc/issue
neofetch --config /usr/share/neofetch/config >> /etc/issue
echo -e "\e[1mUsers\e[0m: $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | sed -z 's/\n/, /g' | sed 's/. $//')" >> /etc/issue
