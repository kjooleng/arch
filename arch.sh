#!/bin/bash

#login as su before running script

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run with root privileges' >&2
    exit 1
fi

#su

#sudo pacman -S reflector rsync curl --noconfirm
sudo pacman -S reflector --noconfirm
reflector -c "SG" -p https --sort rate --save /etc/pacman.d/mirrorlist
sudo nano /etc/pacman.d/mirrorlist

# set swap size
echo Enter desired swap file size in MiB
read swap

# swap file creation
dd if=/dev/zero of=/swapfile bs=1M count=$swap status=progress
chmod 600 /swapfile
mkswap -U clear /swapfile
swapon /swapfile

# configure swap
#cat <<EOF >> /etc/fstab
#/swapfile none swap defaults 0 0
#EOF

echo "  " >> /etc/fstab
echo "/swapfile none swap defaults 0 0" >> /etc/fstab


#Chaotic-AUR
sudo pacman-key --recv-key 3056513887B78AEB 
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'  --noconfirm

# configure pacman.conf
#cat <<EOF >> /etc/pacman.conf
#[chaotic-aur]
#Include = /etc/pacman.d/chaotic-mirrorlist
#EOF

echo "  " >> /etc/pacman.conf
echo "[chaotic-aur]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

sudo pacman -Syu

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
sudo pacman -S vlc gst-libav filezilla openvpn networkmanager-openvpn x11vnc parcellite --noconfirm
#sudo pacman -S vlc gst-libav openvpn networkmanager-openvpn x11vnc parcellite --noconfirm
#sudo pacman -S fuseiso nemo filemanager-actions cdrtools alacarte  --noconfirm
#sudo pacman -S fuseiso nemo gnome-disk-utility cdrtools alacarte  --noconfirm
sudo pacman -S fuseiso nemo gnome-clocks gnome-disk-utility cdrtools alacarte  --noconfirm

#for vm
#sudo pacman -S virtualbox-guest-utils --noconfirm
#systemctl enable vboxservice

#bluetooth
#sudo pacman -S bluez bluez-utils blueman
#sudo systemctl enable bluetooth.service
#sudo systemctl start bluetooth.service

#winetricks corefonts cjkfonts dxvk vkd3d jet40 mdac28 --noconfirm
#winetricks corefonts cjkfonts dxvk vkd3d --noconfirm
#winetricks dotnet35 dotnet40 --noconfirm

# other customisation
sudo pacman -S chaotic-aur/yay --noconfirm
#sudo pacman -S chaotic-aur/trizen --noconfirm
sudo pacman -S chaotic-aur/appimagelauncher --noconfirm
sudo pacman -S chaotic-aur/p7zip-gui --noconfirm
sudo pacman -S chaotic-aur/anydesk --noconfirm
#sudo pacman -S chaotic-aur/firedragon --noconfirm
#sudo pacman -S chaotic-aur/librewolf --noconfirm
#sudo pacman -S chaotic-aur/icecat --noconfirm
#sudo pacman -S chaotic-aur/floorp --noconfirm
#sudo pacman -S chaotic-aur/google-chrome --noconfirm
#sudo pacman -S chaotic-aur/mercury-browser-avx-bin --noconfirm
#sudo pacman -S chaotic-aur/waterfox-bin --noconfirm
sudo pacman -S chaotic-aur/microsoft-edge-stable-bin --noconfirm
#trizen -S appimagelauncher --noconfirm
#sudo pacman -S chaotic-aur/pamac-aur --noconfirm
sudo pacman -S chaotic-aur/pamac --noconfirm
sudo pacman -S chaotic-aur/brave-bin --noconfirm


#no need for running vm
sudo pacman -S chaotic-aur/dropbox --noconfirm
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist
sudo pacman -S chaotic-aur/youtubedl-gui --noconfirm
#sudo pacman -S chaotic-aur/youplay --noconfirm
#sudo pacman -S chaotic-aur/spotify --noconfirm
sudo pacman -S chaotic-aur/video-downloader --noconfirm
sudo pacman -S chaotic-aur/xorgxrdp --noconfirm
#sudo pacman -S chaotic-aur/authy --noconfirm
sudo pacman -S bitwarden --noconfirm
sudo pacman -S clipgrab --noconfirm
#sudo pacman -S reflector rsync curl --noconfirm

#install firewall
yay -S firewalld --noconfirm
sudo systemctl enable firewalld
sudo systemctl start firewalld

# tlp install
sudo pacman -S tlp tlp-rdw --noconfirm
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

yay -S slimbookbattery --noconfirm

#yay -S knock-bin --noconfirm

#yay -S authy-desktop-win32-bin
#exit

