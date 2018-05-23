#!/bin/bash
# ACTION: Install script ps_mem.py
# DESC: Script ps_mem.py show RAM memory usage per process.
# DEFAULT: y

wget -P /usr/bin "https://raw.githubusercontent.com/pixelb/ps_mem/master/ps_mem.py"
chmod +x /usr/bin/ps_mem.py
