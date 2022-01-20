pacman -Sy stow

stow systemd/ -t ~/.config/systemd/
mkdir ~/rclone/googledriver
mkdir ~/mnt/googledriver
mkdir ~/mnt/onedriver

systemctl --user enable rclone_ggdriver.service
systemctl --user enable rclone_onedriver.service
systemctl --user start rclone_ggdriver.service
systemctl --user start rclone_onedriver.service

stow kaggle/ -t ~/
