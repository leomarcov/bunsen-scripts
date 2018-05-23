#!/bin/bash
# ACTION: Install some useful packages
# INFO: Useful packages: vim vlc ttf-mscorefonts-installer fonts-freefont-ttf fonts-droid-fallback rar haveged
# DEFAULT: y
  
packages="vim vlc ttf-mscorefonts-installer fonts-freefont-ttf fonts-droid-fallback rar"
packages="$packages haveged"  # Avoid delay first login in Helium
  
apt-get install -y "$packages"
