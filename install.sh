# install stow

stow linux/home/ -t /home/
stow linux/etc/ -t /etc/

echo user_allow_other >> /etc/fuse.conf
mkdir ~/mnt/googledriver
mkdir ~/mnt/onedriver

systemctl --user enable rclone@googledriver.service
systemctl --user enable rclone@onedriver.service
systemctl --user start rclone@googledriver.service
systemctl --user start rclone@onedriver.service

stow kaggle/ -t ~/
