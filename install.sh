# Better use soft link all the way

# ```
# ln -s /home/<full_path>/dotfile/linux/home/.config/<specific_config_folder> /home/<username>/.config
# ```

# You can use stow for this task, but i can't use it at all tho.

echo user_allow_other >> /etc/fuse.conf

# This install service, which require you already config the rclone drive before hand
mkdir ~/mnt/googledrive
mkdir ~/mnt/onedrive

systemctl --user enable rclone@googledrive.service
systemctl --user enable rclone@onedrive.service
systemctl --user start rclone@googledrive.service
systemctl --user start rclone@onedrive.service

# No need
# stow kaggle/ -t ~/
