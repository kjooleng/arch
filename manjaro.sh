#!/bin/bash

#login as su before running script

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run with root privileges' >&2
    exit 1
fi

#su

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
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
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

sudo pacman -Syuyu

# Uncomment # to include chinese for locale generation
sudo sed -i 's/^# *\(zh_\)/\1/' /etc/locale.gen

sudo locale-gen

# install wine
sudo pacman -Syu wine wine-mono wine-gecko winetricks --noconfirm

# pipewire install for wine
sudo pacman -Syu lib32-pipewire pipewire-pulse lib32-libpulse lib32-gnutls --noconfirm

# pulseaudio install for wine
#sudo pacman -Syu lib32-libpulse lib32-gnutls --noconfirm

# chinese fonts
sudo pacman -Syu adobe-Syuource-han-Syuans-cn-fonts adobe-Syuource-han-Syuans-tw-fonts adobe-Syuource-han-Syuans-hk-fonts --noconfirm

# install IME and other misc
sudo pacman -Syu fcitx5-im fcitx5-chinese-addons --noconfirm

# other apps
sudo pacman -Syu vlc gst-libav filezilla openvpn networkmanager-openvpn x11vnc parcellite --noconfirm
# not needed for mate
sudo pacman -Syu fuseiso nemo filemanager-actions cdrtools alacarte  --noconfirm

#for vm
#pacman -Syu virtualbox-guest-utils --noconfirm
#systemctl enable vboxservice

winetricks corefonts --noconfirm
winetricks dotnet40 cjkfonts --noconfirm

# other customisation
#sudo pacman -Syu chaotic-aur/yay --noconfirm
sudo pacman -Syu chaotic-aur/trizen --noconfirm
sudo pacman -Syu chaotic-aur/p7zip-gui --noconfirm
sudo pacman -Syu chaotic-aur/anydesk --noconfirm
sudo pacman -Syu chaotic-aur/firedragon --noconfirm
sudo pacman -Syu chaotic-aur/librewolf --noconfirm
sudo pacman -Syu chaotic-aur/icecat --noconfirm
sudo pacman -Syu chaotic-aur/google-chrome --noconfirm
sudo pacman -Syu chaotic-aur/mercury-browser-avx-bin --noconfirm
sudo pacman -Syu chaotic-aur/waterfox-bin --noconfirm
sudo pacman -Syu chaotic-aur/microsoft-edge-Syutable-bin --noconfirm
trizen -Syu appimagelauncher --noconfirm
sudo pacman -Syu chaotic-aur/pamac-aur --noconfirm

#no need for running vm
sudo pacman -Syu chaotic-aur/dropbox --noconfirm
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist
sudo pacman -Syu chaotic-aur/youtubedl-gui --noconfirm
#sudo pacman -Syu chaotic-aur/youplay --noconfirm
#sudo pacman -Syu chaotic-aur/spotify --noconfirm
sudo pacman -Syu chaotic-aur/video-downloader --noconfirm
sudo pacman -Syu chaotic-aur/xorgxrdp --noconfirm
sudo pacman -Syu chaotic-aur/authy --noconfirm
sudo pacman -Syu bitwarden --noconfirm
sudo pacman -Syu clipgrab --noconfirm
#sudo pacman -Syu reflector rsync curl --noconfirm


# tlp install
sudo pacman -Syu tlp tlp-rdw --noconfirm
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

yay -Syu slimbookbattery --noconfirm




#exit
