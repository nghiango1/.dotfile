# Config rclone

using 
```sh
rclone config
```

first option (new) set remote name : googledrive (defaut doc/man is remote)
first option name : onedrive

# Install rclone service

This is for automate mount online drive disk at start up using systemd service. Here is the step need to add user created `rclone@.service` to the right location

Using stow from the `install.sh` is fine
```sh
stow systemd/ -t ~/.config/systemd/
```

or use normal soft link, remember to give full path where this located

```sh
ln -s path/to/.dotfile/linux/home/.config/systemd -t ~/.config/
```

The fact that you can just copy the file, but I like to link it for easier config later, easier managing all dotfile in one place

Also, you want to deal with this error

```
fusermount3: option allow_other only allowed if 'user_allow_other' is set in /etc/fuse.conf
```


# Start systemd service

As your normal user, run 

```sh
systemctl --user daemon-reload
```

You can now start/enable each remote by using rclone@<remote>

```sh
systemctl --user enable rclone@ggdrive
systemctl --user start rclone@ggdirve

systemctl --user enable rclone@onedrive
systemctl --user start rclone@onedrive
```
