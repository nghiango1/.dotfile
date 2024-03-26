# Useage

My config file for NixOS

## Run linked binary executable

> Make sure to have the config directory link to `~/workspace/dotfile/nixos/`

In case there is a linked library execuable that we can't deal with, use wraper shell via

```sh
nix-ln-shell "<command>"
```
which is alias for

```sh
nix-shell ~/workspace/dotfile/nixos/glibcLinked.nix --command "<command>"
```

Example usage:
```sh
nix-ln-shell vi
nix-ln-shell "sudo ./execuable -flag=args1 -flag_2 -flag_3"
```

We can also setup a system wide Library, which we just need to enable a config for nix-ld
```nix
{ config, pkgs, ... }:
{
    programs.nix-ld.enable = true;
# It already come with default library, so these just not needed, unless we need more
# programs.nix-ld.libraries = with pkgs; [ alsa-lib at-spi2-atk at-spi2-core atk cairo cups curl dbus expat fontconfig freetype fuse3 gdk-pixbuf glib gtk3 icu libGL libappindicator-gtk3 libdrm libglvnd libnotify libpulseaudio libunwind libusb1 libuuid libxkbcommon libxml2 mesa nspr nss openssl pango pipewire stdenv.cc.cc systemd vulkan-loader xorg.libX11 xorg.libXScrnSaver xorg.libXcomposite xorg.libXcursor xorg.libXdamage xorg.libXext xorg.libXfixes xorg.libXi xorg.libXrandr xorg.libXrender xorg.libXtst xorg.libxcb xorg.libxkbfile xorg.libxshmfence zlib ];
}
```

## Using community repo - vscode extension

Some time, vscode extension is the only way I can get some specific package. But, nixpkgs don't have every packages in the world, so we rely on others comunity repo

```nix
system = builtins.currentSystem;
extensions =
  (import (builtins.fetchGit {
    url = "https://github.com/nix-community/nix-vscode-extensions";
    ref = "refs/heads/master";
  })).extensions.${system};
```

After that, we can just install packages with:
- `extensions.<named-marketplace>.<authors.package-name>`
- `extensions.vscode-marketplace.ms-vscode.js-debug-nightly`

Here is a example with multiple way to install a vscode extension
```nix
environment.systemPackages = with pkgs; [
  # Outsite vscode-with-extensions
  vscode-extensions.ms-vscode.cpptools
  # Install from raw infomation of extension by using vscode-with-extensions
  (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      # Provided package
        ms-vscode.cpptools
        # Community repo import packages
        extensions.vscode-marketplace.ms-vscode.js-debug-nightly
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      }
    ];
  })
```
