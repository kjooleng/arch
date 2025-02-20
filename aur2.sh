#!/bin/bash
#andontie AUR
sudo pacman-key --recv-key 72BF227DD76AE5BF
sudo pacman-key --lsign-key 72BF227DD76AE5BF

echo "  " >> /etc/pacman.conf
echo "[andontie-aur]" >> /etc/pacman.conf
echo "Server = https://aur.andontie.net/\$arch" >> /etc/pacman.conf

sudo pacman -Syu


#Chaotic-AUR
#sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --recv-key 3056513887B78AEB 
#sudo pacman-key --lsign-key FBA220DFC880C036
sudo pacman-key --lsign-key 3056513887B78AEB
#sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm

echo "  " >> /etc/pacman.conf
echo "[chaotic-aur]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

sudo pacman -Sy
