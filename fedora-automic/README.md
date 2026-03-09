# Install

This is atomic version

```sh
rpm-ostree install 
```

Needed

```
➜  rpm-ostree status
State: idle
Deployments:
● fedora:fedora/43/x86_64/sericea
                  Version: 43.1.6 (2025-10-23T03:23:06Z)
               BaseCommit: ...
             GPGSignature: ...
          LayeredPackages: fzf input-remapper neovim rclone ripgrep tmux zsh
```

## Any-other thing

Following rclone for setup cloud storage

```sh
systemctl --user enable rclone@onedriver
```

Ibus will need environment config

- /etc/environment

```sh
WLR_DRM_NO_MODIFIERS=1
WLR_RENDERER=vulkan
XDG_CURRENT_DESKTOP=sway
MOZ_ENABLE_WAYLAND=1
QT_QPA_PLATFORM=wayland
CLUTTER_BACKEND=wayland
SDL_VIDEODRIVER=wayland

# Ibus config for all app start

# gtk application
# eg: gedit
GTK_IM_MODULE=ibus

# kde application - no need, we use sway
# eg: kwrite
# QT_IM_MODULE=ibus

# old X application
# eg: xterm
XMODIFIERS="@im=ibus" 
```

- Then reverse them back `/etc/environment.d/ibus-custom.conf`

```sh
# cat /etc/environment.d/ibus-custom.conf 
# Ibus config for all app start
# gtk application
unset GTK_IM_MODULE=ibus
# kde application
unset QT_IM_MODULE=ibus
# old X application
unset XMODIFIERS
```
