![seleccion_827](https://user-images.githubusercontent.com/32820131/40361602-3476698e-5dca-11e8-9aa4-2d91e4e734eb.png)

## BunsenLabs-Postinstall
**`bl-postinstall.sh`**: my personal postinstall script, themes and configs for BunsenLabs Helium.  
Althoughs is a collection of my particular useful packages and configs may be interesting for you.  
The script exec many predefined action:

```bash
# List all actions:
$ ./bl-postinstall.sh -l
[1] INSTALL: some useful packages
[2] INSTALL AND CONFIG AS DEFAULT: rofi launcher
[3] INSTALL: PlayOnLinux
[4] INSTALL AND ADD REPOSITORIES: Sublime-Text 3
[5] INSTALL AND ADD REPOSITORIES: Google Chrome
[6] INSTALL AND ADD REPOSITORIES: VirtualBox
[7] INSTALL: Extension Pack
[8] INSTALL: script update-notification.sh for notify weekly for updates in tint bar
[9] INSTALL: script autosnap.sh for autosnap windows when center click in title
[10] INSTALL: script ps_mem.py for show RAM usage por process
[11] INSTALL: script brightness.sh for control brightness
[12] INSTALL AND CONFIG AS DEFAULT: Aptenodytes Forsteri Wallpaper by Nixiepro
[13] INSTALL AND CONFIG AS DEFAULT: Numix-Paper icon theme
[14] INSTALL: some cool fonts
[15] INSTALL AND SET AS DEFAULT: Openbox theme
[16] INSTALL AND CONFIG AS DEFAULT: Arc GTK theme
[17] INSTALL AND CONFIG AS DEFAULT: Terminator theme
[18] INSTALL AND CONFIG AS DEFAULT: new conky default
[19] INSTALL AND CONFIG AS DEFAULT: tin2 theme
[20] CONFIG: disable graphical display manager and install text locker
[21] CONFIG: enable CTRL+ALT+BACKSPACE for kill X server
[22] CONFIG: disable some stupid services
[23] CONFIG: skip GRUB menu and enter Bunsen directly
[24] CONIFG: show messages during boot
[25] CONFIG: bl-exit classic theme
[26] CONFIG: some useful aliases
[27] CONFIG: new bash prompt
[28] Set default brightness when start openbox (edit value in /usr/bin/brightness.sh)

# Exec all actions:
$ sudo ./bl-postinstall.sh -y

# Exec all actions and answer yes to all:
$ sudo ./bl-postinstall.sh -y

# Exec only actions 5,7,10,11,12,13,14 and 15:
$ sudo ./bl-postinstall.sh -a 5,7,10-15
```

</br>

## Autosnap Windows for Openbox
[**`autosnap.sh`**](https://github.com/leomarcov/BunsenLabs-Postinstall/tree/master/autosnap-openbox): script for **autosnap windows** (half-maximice) in Openbox WM.  
The script snap the active windows an choose automatically the corner to snap according the mouse position: if the mouse is in the zone of corner left snap to this quadrant, if is in the center left snap to half left screen, if is in the center maximize the windows, etc.  
It should work in **1 or 2 monitors** (in horizontal).

![peek-12-10-2017-20-43](https://user-images.githubusercontent.com/32820131/40352231-9d64c1fa-5dae-11e8-8137-890cadf2c293.gif)

</br>

## Update Notification for tint 
[**`updagte-notification.sh`**](https://github.com/leomarcov/BunsenLabs-Postinstall/tree/master/update-notification-tint): script that checks periodically APT pending updates and show a notification in tint2 bar using executor plugin (since tint2 0.12.4).  

![seleccion_825](https://user-images.githubusercontent.com/32820131/40354912-55396e4c-5db5-11e8-9b22-aaeedc7e91e3.png)

</br>

## Numix-Paper icon theme
[**`numix-paper-icon-theme.zip`**](https://github.com/leomarcov/BunsenLabs-Postinstall/tree/master/numix-paper-icon-theme): icon theme based on Numix and Paper themes.  
The theme has been generated completely using symbolic links to Numix and Paper folders.

The theme contains:
  * Folder icons: grey icons from Numix (instead of yellow).
  * Panel icons: panel icons from Paper.
  * Apps icons: apps icons from Paper.
  * Rest come from Numix theme.
  
![numix-paper-icon-theme](https://user-images.githubusercontent.com/32820131/40285580-32b6e22c-5c9e-11e8-8567-01f56d1c12db.png)



