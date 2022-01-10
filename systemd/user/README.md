# Config rclone
using 
'''
rclone config
'''
first option (new) set remote name : googledriver (defaut doc/man is remote)
first option name : onedriver

rename if nessary
# Start systemd service
As your normal user, run 
  systemctl --user daemon-reload
You can now start/enable each remote by using rclone@<remote>
  systemctl --user enable rclone@dropbox
  systemctl --user start rclone@dropbox