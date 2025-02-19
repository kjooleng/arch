#!/bin/bash

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
