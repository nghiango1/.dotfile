{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  # Include the results of the hardware scan.
  imports =
    [ 
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Define hostname.
  networking.hostName = "nec-pc";
  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;  

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ylong = {
    isNormalUser = true;
    description = "ylong";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  home-manager.users.ylong = {
    home.stateVersion = "23.11";
    
    programs.git = {
      enable = true;
      userName  = "nghiango1";
      userEmail = "ducnghia.tin47@gmail.com";
    };

    programs.neovim.plugins = with pkgs.vimPlugins; [
    ];

  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xclip
    lua
    unzip
    go
    gcc
    nodejs
    python3
    wget
    keepassxc
    rclone
    fzf
    
    gnomeExtensions.dash-to-dock
    gnomeExtensions.topicons-plus
    gnomeExtensions.appindicator
  ];

  services.gnome.gnome-browser-connector.enable = true;
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org/gnome/shell]
    app-picker-view=uint32 1
    enabled-extensions=['dash-to-dock@micxgx.gmail.com', 'TopIcons@phocean.net', ]
    had-bluetooth-devices-setup=true
    favorite-apps=['org.gnome.Terminal.desktop', 'firefox.desktop', 'org.gnome.Nautilus.desktop']

    [org/gnome/shell/extensions/dash-to-dock]
    preferred-monitor=0
    multi-monitor=false
    height-fraction=0.90000000000000002
    dash-max-icon-size=64
    icon-size-fixed=true
  '';

  i18n.inputMethod = {
    enabled = "ibus";
    ibus = {
      engines = with pkgs.ibus-engines; [ hangul bamboo ];
    };
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Ubuntu" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Ubuntu" ];
      };
    };
  };

  environment.variables = rec {
    VISUAL = "nvim";
  };

  environment.sessionVariables = rec {
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ 
      "${XDG_BIN_HOME}"
    ];
  };

  environment.shellAliases = {
    sudovi = "sudo -E -s nvim";
    # Hack for sudo alias to work, check https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
    sudo = "sudo ";
    # Alias for linked library wraper shell
    nix-ln-shell = "nix-shell ~/workspace/dotfile/nixos/glibcLinked.nix --command";
  };

  # This help dynamic linked executable, which pair with `nix-ln-shell` alias
  # eg: Mason prebuild LSP server
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    fuse3
    gdk-pixbuf
    glib
    gtk3
    icu
    libGL
    libappindicator-gtk3
    libdrm
    libglvnd
    libnotify
    libpulseaudio
    libunwind
    libusb1
    libuuid
    libxkbcommon
    libxml2
    mesa
    nspr
    nss
    openssl
    pango
    pipewire
    stdenv.cc.cc
    systemd
    vulkan-loader
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxkbfile
    xorg.libxshmfence
    zlib
  ];

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    baseIndex = 1;
    historyLimit = 10000;
    escapeTime = 0;
    clock24 = true;
    customPaneNavigationAndResize = true;
    extraConfig = ''
    # First remove *all* keybindings
    unbind C-b
    set-option -g prefix M-a
    bind-key M-a send-prefix
    set -g status-style 'bg=#333334 fg=#5eacd3'

    # Vim like
    bind -T copy-mode-vi v send-keys -X begin-selection
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

    # Fzf any session
    bind-key -r f run-shell "tmux neww tmuxhelper.sh"

    # Copy mode
    bind-key [ copy-mode

    # Paste buffer
    bind-key ] paste-buffer

    # Clock
    setw -g clock-mode-style 24
    setw -g monitor-activity on
    
    # Mouse on/off
    set -g mouse off

    # Automatically set window title
    set-window-option -g automatic-rename on
    set-option -g set-titles on

    # Choose Window
    bind-key w choose-window

    # New Window with number
    bind-key 1 new-window -t 1
    bind-key 2 new-window -t 2
    bind-key 3 new-window -t 3
    bind-key 4 new-window -t 4
    bind-key 5 new-window -t 5
    bind-key 6 new-window -t 6
    bind-key 7 new-window -t 7
    bind-key 8 new-window -t 8
    bind-key 9 new-window -t 9
    bind-key 0 new-window -t 10

    # Switch windows alt+number
    bind-key -n M-1 select-window -t 1
    bind-key -n M-2 select-window -t 2
    bind-key -n M-3 select-window -t 3
    bind-key -n M-4 select-window -t 4
    bind-key -n M-5 select-window -t 5
    bind-key -n M-6 select-window -t 6
    bind-key -n M-7 select-window -t 7
    bind-key -n M-8 select-window -t 8
    bind-key -n M-9 select-window -t 9
    bind-key -n M-0 select-window -t 10

    # Change current pane to next window
    bind-key ! join-pane -t :1
    bind-key @ join-pane -t :2
    bind-key '#' join-pane -t :3
    bind-key '$' join-pane -t :4
    bind-key '%' join-pane -t :5
    bind-key '^' join-pane -t :6
    bind-key '&' join-pane -t :7
    bind-key '*' join-pane -t :8
    bind-key '(' join-pane -t :9
    bind-key ')' join-pane -t :10

    # Kill Selected Pane
    bind-key Q kill-pane
    '';
  };

  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user.name = "nghiango1";
      user.email = "ducnghia.tin47@gmaill.com";
    };
  };

  programs.fuse.userAllowOther = true;

  # Neovim setup
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  systemd.user.services.ggdrive = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      description = "rclone: Remote FUSE filesystem for cloud storage config %i";
      serviceConfig = {
        Type = "notify";
        ExecStart = ''${pkgs.rclone}/bin/rclone mount --config=%h/.config/rclone/rclone.conf --cache-dir=%h/mnt/cache-ggdrive --log-file=/tmp/rclone-ggdrive.log --poll-interval 15s --allow-other --dir-cache-time 1000h --log-level INFO --vfs-cache-mode full --vfs-cache-max-size 100G --vfs-cache-max-age 120h --bwlimit-file 16M ggdrive: %h/mnt/ggdrive'';
        ExecStop = ''/run/wrappers/bin/fusermount -u %h/mnt/ggdrive'';   
      };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
