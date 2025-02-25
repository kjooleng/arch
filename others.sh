#!/bin/bash

arch-chroot /mnt pacman -S chaotic-aur/yay --noconfirm
arch-chroot /mnt yay -S chaotic-aur/pamac --noconfirm
arch-chroot /mnt yay -S chaotic-aur/appimagelauncher --noconfirm
arch-chroot /mnt yay -S chaotic-aur/p7zip-gui --noconfirm
arch-chroot /mnt yay -S chaotic-aur/anydesk --noconfirm
arch-chroot /mnt yay -S chaotic-aur/microsoft-edge-stable-bin --noconfirm
arch-chroot /mnt yay -S chaotic-aur/brave-bin --noconfirm
#arch-chroot /mnt yay -S chaotic-aur/firedragon --noconfirm
#arch-chroot /mnt yay -S chaotic-aur/librewolf --noconfirm
#arch-chroot /mnt yay -S chaotic-aur/icecat --noconfirm
#arch-chroot /mnt yay -S chaotic-aur/floorp --noconfirm
#arch-chroot /mnt yay -S chaotic-aur/google-chrome --noconfirm
#arch-chroot /mnt yay -S chaotic-aur/mercury-browser-avx-bin --noconfirm
#arch-chroot /mnt yay -S chaotic-aur/waterfox-bin --noconfirm

#no need for running vm

#sudo pacman -S chaotic-aur/youplay --noconfirm
#sudo pacman -S chaotic-aur/spotify --noconfirm

arch-chroot /mnt yay -S chaotic-aur/video-downloader --noconfirm
arch-chroot /mnt yay -S chaotic-aur/xorgxrdp --noconfirm
arch-chroot /mnt pacman -S bitwarden --noconfirm
arch-chroot /mnt pacman -S clipgrab --noconfirm

#install firewall
arch-chroot /mnt yay -S firewalld --noconfirm
sudo arch-chroot /mnt systemctl enable firewalld
sudo arch-chroot /mnt systemctl start firewalld

# tlp install
sudo arch-chroot /mnt pacman -S tlp tlp-rdw --noconfirm
sudo arch-chroot /mnt systemctl enable tlp.service
sudo arch-chroot /mnt systemctl enable NetworkManager-dispatcher.service
sudo arch-chroot /mnt systemctl mask systemd-rfkill.service systemd-rfkill.socket

reboot
if [ -d /sys/firmware/efi/efivars/ ]; then #for uefi
	echo "Shutting down....";
	#shutdown now
 	reboot
	
else	#for bios
	echo "Rebooting....";	
    	reboot

fi
