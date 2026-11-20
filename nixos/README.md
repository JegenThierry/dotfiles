# Nix OS

Work in Progress

## Commands

Add unstable: 

```bash
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --update
```

Update system 

```bash
sudo nixos-rebuild switch --upgrade
```