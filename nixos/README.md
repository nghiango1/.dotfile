# Useage

My config file for NixOS

## Run linked binary

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
