#!/bin/bash

#!/bin/bash

# further customisation
# startx

#login as su before running script

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run with root privileges' >&2
    exit 1
fi

# set swap size
echo Enter desired swap file size in MiB
read swap

# swap file creation
dd if=/dev/zero of=/swapfile bs=1M count=$swap status=progress
chmod 600 /swapfile
mkswap -U clear /swapfile
swapon /swapfile

echo "  " >> /etc/fstab
echo "/swapfile none swap defaults 0 0" >> /etc/fstab

#no need if not using arch install
#sudo pacman -S reflector rsync curl --noconfirm
#sudo reflector -c "SG" -p https --sort rate --save /etc/pacman.d/mirrorlist

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
