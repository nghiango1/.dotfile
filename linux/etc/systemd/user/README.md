# Config rclone
using 
'''
rclone config
'''
first option (new) set remote name : googledriver (defaut doc/man is remote)
first option name : onedriver

rename if nessary
# install
'''
stow systemd/ -t ~/.config/systemd/
systemctl --user enable rclone_ggdriver.service
systemctl --user enable rclone_onedriver.service
systemctl --user start rclone_ggdriver.service
systemctl --user start rclone_onedriver.service
'''
# Start systemd service
As your normal user, run 
'''
systemctl --user daemon-reload
'''
You can now start/enable each remote by using rclone@<remote>
'''
  systemctl --user enable rclone@dropbox
  systemctl --user start rclone@dropbox
'''