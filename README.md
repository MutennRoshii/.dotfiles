# .dotfiles

My personal dotfile repository for my linux desktop

> OS: Ubuntu-23.10

## Setup

I use nala as my apt frontend

```bash
sudo apt update && sudo apt install nala
```

### Installing config files

```bash
dotfiles=~/.dotfiles

cp -sf $dotfiles/.bash_logout ~/.bash_logout
cp -sf $dotfiles/.bashrc ~/.bashrc
cp -sf $dotfiles/.profile ~/.profile
cp -rsf $dotfiles/.config/. ~/.config/
```

### Installing native packages using nala

```bash

sudo nala install alacritty build-essential cmake curl \
fzf git gnome-software gnome-tweaks libbz2-dev libffi-dev \
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

mise p i -y maven gradle

mise u -g node@20
mise u -g python@3.10
mise u -g python@3.12
mise u -g java@17
mise u -g java@21
mise u -g maven@3.9.6
mise u -g gradle@8.5

bob use stable
```

## System cleanup

### Remove snaps & other packages

```bash
sudo snap remove --purge firefox
sudo snap remove --purge snap-store
sudo snap remove --purge gnome-42-2204
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge firmware-updater
sudo snap remove --purge bare
sudo snap remove --purge snapd-desktop-integration
sudo snap remove --purge core22
sudo snap remove --purge snapd

sudo nala remove --autoremove snapd
sudo nala remove --autoremove vim-tiny
sudo nala autopurge && sudo nala autoremove

echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" > /etc/apt/preferences.d/nosnap.pref

sudo nala install --install-suggests gnome-software
```

### Installing firefox

```bash
sudo add-apt-repository ppa:mozillateam/ppa

echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

echo "Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 501" > /etc/apt/preferences.d/mozillateamppa

sudo apt update && sudo nala update
sudo nala install -t 'o=LP-PPA-mozillateam' firefox
```

### Installing glow

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list

sudo apt update && sudo nala update
sudo nala install glow
```

### Sudoers

```bash
sudoedit /etc/bash.bashrc   # remove sudo hint
sudoedit /etc/sudoers       # add `Defaults !admin_flag`
rm ~/.sudo_as_admin_successful
```
