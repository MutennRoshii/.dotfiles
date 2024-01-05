# .dotfiles

My personal dotfile repository for my linux desktop

> OS: Ubuntu-23.10 <br>
> DE: Gnome <br>
> PM: Nala <br>

## Setup

```bash
cd
sudo apt update && sudo apt install nala
sudo nala install git
git clone https://github.com/MutennRoshii/.dotfiles.git
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
fzf gnome-software gnome-tweaks libbz2-dev libffi-dev \
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
Pin-Priority: -10" | sudo tee /etc/apt/preferences.d/nosnap.pref

sudo nala install --install-suggests gnome-software
```

### Installing firefox

```bash
sudo add-apt-repository ppa:mozillateam/ppa

echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

echo "Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 501" | sudo tee /etc/apt/preferences.d/mozillateamppa

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

## Ricing

### Fonts

```bash
cd ~/Downloads 

curl -s 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' \
| jq -r ".assets[] | .browser_download_url" \
| grep -E -i "ttf-iosevka-" \
| xargs -n 1 curl -LO --fail --silent --show-error

unzip ./*.zip
rm ./*.zip ./*.txt ./*.md
mkdir Iosevka
mv ./*.ttf ./Iosevka/

curl -s 'https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest' \
| jq -r ".assets[] | .browser_download_url" \
| grep -E -i "jetbrainsmono.*\.zip" \
| xargs -n 1 curl -LO --fail --silent --show-error

unzip ./*.zip
rm ./*.zip ./*.txt ./*.md
rm ./*Propo-*.ttf ./*Mono-*.ttf ./*NL*.ttf
mkdir JetBrainsMonoNerdFont
mv ./*.ttf ./JetBrainsMonoNerdFont/

sudo mv ./Iosevka/ /usr/share/fonts/
sudo mv ./JetBrainsMonoNerdFont/ /usr/share/fonts/
```

### Grub

```bash
sudo grub-mkfont -s 18 -o /boot/grub/iosevka-18.pf2 /usr/share/fonts/Iosevka/Iosevka-Regular.ttf

sudo cp /etc/default/grub /etc/default/grub.bak
echo "GRUB_FONT=/boot/grub/iosevka-18.pf2" | sudo tee -a /etc/default/grub

sudo grub-mkconfig -o /boot/efi/EFI/ubuntu/grub.cfg
```

## Modified system files

I will list all system files that have been modified or added in this README:

| file                                                          | action |
|---------------------------------------------------------------|--------|
| /etc/sudoers                                                  | edited |
| /etc/bash.bashrc                                              | edited |
| /etc/apt/keyrings/charm.gpg                                   | added  |
| /etc/apt/sources.list.d/charm.list                            | added  |
| /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-mantic.sources | added  |
| /etc/apt/preferences.d/nosnap.pref                            | added  |
| /etc/apt/preferences.d/mozillateamppa                         | added  |
| /etc/apt/apt.conf.d/51unattended-upgrades-firefox             | added  |
