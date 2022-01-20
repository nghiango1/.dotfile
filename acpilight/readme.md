# IF SOME HOW NORMAL INSTALL NOT WORKING

"acpilight" is a backward-compatibile replacement for xbacklight that uses the ACPI interface to set the display brightness

This will be need if arco can't controll the light

xbacklight will need sudo for setting the display tho
'''
sudo stow rules.d -d etc/udev/ -t /etc/udev/rules.d/stow -t /etc/
'''

Instead using a udev for sys level video app group, which make Light packet can now be use. 
'''
sudo udevadm control --reload
sudo pacman -Sy light
'''