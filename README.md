# .dotfiles

My personal dotfile repository for my linux desktop

> OS: Ubuntu-23.10

## Setup

### Installing config files

```bash
cp -sf $dotfiles/.bashrc ~/.bashrc
cp -sf $dotfiles/.profile ~/.profile
cp -rsf $dotfiles/.config/. ~/.config/
```

### Installing native packages using nala

```bash
sudo apt update && sudo apt install nala

sudo nala install alacritty build-essential cmake curl firefox \
fzf git glow gnome-software gnome-tweaks libbz2-dev libffi-dev \
liblzma-dev libncurses-dev libreadline-dev libsqlite3-dev \
libssl-dev  ibxml2-dev libxmlsec1-dev tk-dev zlib1g-dev
```

### Installing lovely rust tools

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install sccache

RUSTC_WRAPPER=sccache cargo install mise bob-nvim cargo-info du-dust eza fd-find ripgrep sccache starship
```

### Installing tools with mise & bob

```bash
mise activate bash

mise use -g node@20
```
