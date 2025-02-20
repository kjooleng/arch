#!/bin/bash
#andontie AUR
sudo arch-chroot /mnt pacman-key --recv-key 72BF227DD76AE5BF
sudo arch-chroot /mnt pacman-key --lsign-key 72BF227DD76AE5BF

echo "  " >> /mnt/etc/pacman.conf
echo "[andontie-aur]" >> /mnt/etc/pacman.conf
echo "Server = https://aur.andontie.net/\$arch" >> /mnt/etc/pacman.conf

arch-chroot /mnt pacman -Syu


#Chaotic-AUR
#sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo arch-chroot /mnt pacman-key --recv-key 3056513887B78AEB 
#sudo pacman-key --lsign-key FBA220DFC880C036
sudo arch-chroot /mnt pacman-key --lsign-key 3056513887B78AEB
#sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo arch-chroot /mnt pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm

echo "  " >> /mnt/etc/pacman.conf
echo "[chaotic-aur]" >> /mnt/etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /mnt/etc/pacman.conf

arch-chroot /mnt pacman -Sy
