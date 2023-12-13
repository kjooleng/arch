#!/bin/bash

# Uncomment # to include chinese for locale generation
sudo sed -i 's/^# *\(zh_\)/\1/' /etc/locale.gen

sudo locale-gen

# install wine
sudo pacman -S wine wine-mono wine-gecko winetricks --noconfirm

# pipewire install
sudo pacman -S lib32-pipewire pipewire-pulse lib32-libpulse lib32-gnutls --noconfirm

# chinese fonts
sudo pacman -S adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-sans-hk-fonts --noconfirm

# install IME and other misc
sudo pacman -S fcitx5-im fcitx5-chinese-addons --noconfirm

# other apps
sudo pacman -S vlc filezilla openvpn networkmanager-openvpn x11vnc parcellite --noconfirm

#Chaotic-AUR
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'  --noconfirm

# configure pacman.conf
sudo cat <<EOF >> /etc/pacman.conf
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF

sudo pacman -Syu
