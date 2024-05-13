#!/bin/bash

# further customisation
# startx

#Chaotic-AUR
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'  --noconfirm

echo "  " >> /etc/pacman.conf
echo "[chaotic-aur]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

#Trinity repo
#sudo pacman-key --recv-key  D6D6FAA25E9A3E4ECD9FBDBEC93AF1698685AD8B
#sudo pacman-key --lsign-key D6D6FAA25E9A3E4ECD9FBDBEC93AF1698685AD8B

#sudo nano /etc/pacman.conf
# Uncomment for chaotic and trinity repo
#sudo sed -i 's/^# *\(chaotic\)/\1/' /etc/pacman.conf
#sudo sed -i 's/^# *\(trinity\)/\1/' /etc/pacman.conf

sudo pacman -Syu

# install wine
#sudo pacman -Syu
#sudo pacman -S wine wine-mono wine-gecko winetricks --noconfirm
#wine --version
winetricks corefonts 
winetricks dotnet40 cjkfonts
#winetricks corefonts cjkfonts
#sudo pacman -S lib32-pipewire pipewire-pulse lib32-libpulse lib32-gnutls --noconfirm
#sudo pacman -S adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-sans-hk-fonts --noconfirm

# install trinity desktop
#sudo pacman -S tde-tdebase --noconfirm

# install enlightenment desktop
#sudo pacman -S enlightenment --noconfirm

# other customisation
sudo pacman -S chaotic-aur/yay --noconfirm
sudo pacman -S chaotic-aur/trizen --noconfirm
sudo pacman -S chaotic-aur/p7zip-gui --noconfirm
sudo pacman -S chaotic-aur/anydesk --noconfirm
#sudo pacman -S chaotic-aur/firedragon --noconfirm
sudo pacman -S chaotic-aur/librewolf --noconfirm
#sudo pacman -S chaotic-aur/icecat --noconfirm
sudo pacman -S chaotic-aur/google-chrome --noconfirm
#sudo pacman -S chaotic-aur/mercury-browser-avx-bin --noconfirm
#sudo pacman -S chaotic-aur/waterfox-bin --noconfirm
trizen -S appimagelauncher --noconfirm
sudo pacman -S chaotic-aur/pamac-aur --noconfirm

#no need for running vm

#sudo pacman -S chaotic-aur/dropbox --noconfirm
#rm -rf ~/.dropbox-dist
#install -dm0 ~/.dropbox-dist
sudo pacman -S chaotic-aur/youtubedl-gui --noconfirm
#sudo pacman -S chaotic-aur/youplay --noconfirm
#sudo pacman -S chaotic-aur/spotify --noconfirm
sudo pacman -S chaotic-aur/video-downloader --noconfirm
sudo pacman -S chaotic-aur/xorgxrdp --noconfirm
#sudo pacman -S chaotic-aur/authy --noconfirm
sudo pacman -S bitwarden --noconfirm
sudo pacman -S clipgrab --noconfirm
sudo pacman -S reflector rsync curl --noconfirm

#Install pamac from AUR
#curl -o pamac-all.zip -SL https://bit.ly/432WEQH
#curl -o libpamac-full.zip -SL https://bit.ly/3pRdUKi
#curl -o snapd.zip -SL https://bit.ly/3Ifxiak
#curl -o snapd-glib.zip -SL https://bit.ly/3pMnMFi

#unzip '*.zip'

#cd snapd
#makepkg -si --noconfirm
#cd

#cd snapd-glib
#makepkg -si --noconfirm
#cd

#cd libpamac-full
#makepkg -si --noconfirm
#cd

#cd pamac-all
#makepkg -si --noconfirm
#cd

# tlp install
sudo pacman -S tlp tlp-rdw --noconfirm
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

yay -S slimbookbattery --noconfirm

# choose one only
#yay -S slimbookintelcontroller --noconfirm
#yay -S slimbookamdcontroller --noconfirm




sudo shutdown now
