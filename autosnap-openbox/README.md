# Autosnap Windows for Openbox
Script for **autosnap windows** (half-maximice) in Openbox WM.  
The script snap the active windows an choose automatically the corner to snap according the mouse position: if the mouse is in the zone of corner left snap to this quadrant, if is in the center left snap to half left screen, if is in the center maximize the windows, etc.  
It should work in **1 or 2 monitors** (in horizontal).

![peek-12-10-2017-20-43](https://user-images.githubusercontent.com/32820131/40352231-9d64c1fa-5dae-11e8-8137-890cadf2c293.gif)

## Install
  * Copy the script to accessible PATH directory and make it executable.
  ```bash
  cp autosnap.sh /usr/bin/
  chmod +x /usr/bin/autosnap.sh
  ```
  * Edit Openbox config file `rc.xml` and config mouse duble click to exec  `command autosnap.sh`:
```xml
    <context name="Titlebar">
...
      <mousebind button="Left" action="DoubleClick">
        <action name="Execute">
          <command>autosnap.sh</command>
        </action>        
      </mousebind>
...
    </context>
```
