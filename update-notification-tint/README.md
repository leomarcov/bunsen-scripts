# Update Notification for tint 
Script that checks periodically apt pending updates and show a notification in tint2 bar using executor plugin (since tint2 0.12.4).  

![seleccion_825](https://user-images.githubusercontent.com/32820131/40354912-55396e4c-5db5-11e8-9b22-aaeedc7e91e3.png)

## Install
  * Download `update-notification.sh` script and install the script:
```bash
sudo update-notification -I 
```
  * Edit your tint2 config for add a new executor:
```
execp = new
execp_command = update-notification.sh -m
execp_lclick_command = x-terminal-emulator -b -e update-notification.sh -i
execp_tooltip = Pending updates...
execp_interval = 0
execp_padding = 8 0 0
execp_background_id = 4
execp_font = Droid Sans 10
execp_font_color = #FFFFFF 100
execp_centered = 1
```
