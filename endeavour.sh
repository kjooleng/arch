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

# other apps
sudo pacman -S vlc filezilla openvpn networkmanager-openvpn x11vnc parcellite --noconfirm
