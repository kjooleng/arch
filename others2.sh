#!/bin/bash

#andontie AUR
sudo pacman-key --recv-key 72BF227DD76AE5BF
sudo pacman-key --lsign-key 72BF227DD76AE5BF

echo "  " >> /mnt/etc/pacman.conf
echo "[andontie-aur]" >> /mnt/etc/pacman.conf
echo "Server = https://aur.andontie.net/\$arch" >> /mnt/etc/pacman.conf

sudo pacman -Syu


#Chaotic-AUR
#sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --recv-key 3056513887B78AEB 
#sudo pacman-key --lsign-key FBA220DFC880C036
sudo pacman-key --lsign-key 3056513887B78AEB
#sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm

echo "  " >> /mnt/etc/pacman.conf
echo "[chaotic-aur]" >> /mnt/etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /mnt/etc/pacman.conf

arch-chroot /mnt pacman -Sy

sudo pacman -S chaotic-aur/yay --noconfirm
yay -S chaotic-aur/pamac --noconfirm
yay -S chaotic-aur/appimagelauncher --noconfirm
yay -S chaotic-aur/p7zip-gui --noconfirm
yay -S chaotic-aur/anydesk --noconfirm
yay -S chaotic-aur/microsoft-edge-stable-bin --noconfirm
yay -S chaotic-aur/brave-bin --noconfirm
yay -S chaotic-aur/firedragon --noconfirm
yay -S chaotic-aur/librewolf --noconfirm
#yay -S chaotic-aur/icecat --noconfirm
#yay -S chaotic-aur/floorp --noconfirm
#yay -S chaotic-aur/google-chrome --noconfirm
#yay -S chaotic-aur/mercury-browser-avx-bin --noconfirm
#yay -S chaotic-aur/waterfox-bin --noconfirm

#no need for running vm

#sudo pacman -S chaotic-aur/youplay --noconfirm
#sudo pacman -S chaotic-aur/spotify --noconfirm

yay -S chaotic-aur/video-downloader --noconfirm
yay -S chaotic-aur/xorgxrdp --noconfirm
sudo pacman -S bitwarden --noconfirm
sudo pacman -S clipgrab --noconfirm

#install firewall
yay -S firewalld --noconfirm
systemctl enable firewalld
systemctl start firewalld

# tlp install
sudo pacman -S tlp tlp-rdw --noconfirm
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

if [ -d /sys/firmware/efi/efivars/ ]; then #for uefi
	echo "Shutting down....";
	shutdown now
	
else	#for bios
	echo "Rebooting....";	
    reboot

fi
