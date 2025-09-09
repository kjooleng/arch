#!/bin/bash
curl -o install.sh -SL https://bit.ly/42Z4SsR
#curl -o time.sh -SL https://bit.ly/3B6BGEw
curl -o wine.sh -SL https://bit.ly/3XrNsnz
#curl -o disk.sh -SL https://raw.githubusercontent.com/kjooleng/arch/main/disk.sh
curl -o disk.sh -SL https://bit.ly/44SFwPC
#curl -o disk.sh -SL https://t.ly/bpO3n
#curl -o disk.sh -SL https://shorturl.at/cMTgd
curl -o others.sh -SL https://bit.ly/43456Cu
curl -o arch.sh -SL https://bit.ly/42biuUq
curl -o aur2.sh -SL https://bit.ly/4hdL0JD

curl -o locale.gen -SL https://bit.ly/46pMfBd
curl -o pacman.conf -SL https://bit.ly/44iJTCR
#curl -o sudoers -SL https://bit.ly/3NxuE1v

#for archbang only
#pacman -Sy reflector --noconfirm

#script cleanup
pacman -Sy dos2unix --noconfirm

dos2unix install.sh
dos2unix others.sh

nano install.sh
nano others.sh

#nano time.sh

nano wine.sh

nano locale.gen

nano pacman.conf
nano disk.sh

#nano sudoers


# edit locale.gen if you need to change language options
# nano locale.gen

chmod +x install.sh
chmod +x others.sh

#chmod +x time.sh

sudo ./install.sh

exit

# KJL install of Arch Linux (BIOS or UEFI install)
# 
# Based on https://www.linuxfordevices.com/tutorials/linux/how-to-install-arch-linux and
# https://www.linuxfordevices.com/tutorials/linux/how-to-install-gui-on-arch-linux

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run with root privileges' >&2
    exit 1
fi


# check if internet connection exists
ping -q -c 1 archlinux.org >/dev/null || { echo "No Internet Connection!; "exit 1; }

# get fastest mirror, replace with your own country code
reflector -c "SG" -p https --sort rate --save /etc/pacman.d/mirrorlist
nano /etc/pacman.d/mirrorlist

pacman -Sy dialog --noconfirm

# choose device for installing Arch
devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac) #list devices of only their name and size, excluding non disks, tac prints in rev order
IN_DEVICE=$(dialog --stdout --menu "Select disk to install to" 0 0 0 ${devicelist}) || exit 1 #redirect output to stdout to variable, if unsuccessful command exit 1

clear

# define memory for swap size
#MEMORY_SIZE="$(grep MemTotal /proc/meminfo | awk '{print $2}')"
#MEMORY_SIZE=3G

# set swap size
echo Enter desired swap file size in MiB
read swap

# set username
while true; do               
        read -r -p "Enter username: " USERNAME
        [[ "$USERNAME" =~ ^[0-9,a-z,A-Z]*$ ]] && break;
        echo "Only letters and numbers allowed"
done

# set password
while true; do
    read -r -s -p "Enter password used for user and root: " NEW_PASSWORD
    echo
    read -r -s -p "Password (again): " password2
    echo
    [ "$NEW_PASSWORD" = "$password2" ] && break
    echo "Please try again"
done

# set hostname
# shellcheck disable=SC2002
DEFAULT_HOSTNAME="$(cat /sys/devices/virtual/dmi/id/product_name | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
read -r -p "Enter hostname (press enter for default: ${DEFAULT_HOSTNAME}): " HOSTNAME
if [ -z "${NEW_HOSTNAME}" ]; then
  HOSTNAME=${DEFAULT_HOSTNAME}
fi

# Type of display installation
echo "Choose display driver to install:"
echo "(1)Intel, AMD or NVidia"
echo "(2)VirtualBox"
echo "(3)Qemu"
echo "Select 1, 2 or 3 only"
read install_type

# choose to install pipewire or pulseaudio
echo "Install pipewire? (y/n)"
read pipe_install

# choose to desktop environment
echo "Choose desktop environment to install"
echo "1) Cutefish"
echo "2) UKUI"
echo "3) Mate"
echo "4) Budgie"
echo "5) Gnome"
echo "6) LXDE"
echo "7) Enlightenment"
echo "8) XFCE"
echo "9) LXQT"
echo "Select one choice only"
read desktop_install

# update system clock
timedatectl set-ntp true


# old partition method
#if [ -d /sys/firmware/efi/efivars/ ]; then #for uefi
	#echo "Creating UEFI partition";
	#sleep 5

#=====================================================================
#For UEFI

# check if boot type is UEFI
#ls /sys/firmware/efi/efivars || { echo "Boot Type Is Not UEFI!; "exit 1; }

#UEFI_install=1

#partition disk
#cfdisk /dev/sda

#mkfs.fat -F32 /dev/sda2
#Replace /dev/sda2 with the name of your EFI System partition.
 
#mkfs.ext4 /dev/sda3
#Replace /dev/sda3 with the name of your root partition.
 
#Initialising Swap partition:
#mkswap /dev/sda1
#swapon /dev/sda1
#Replace /dev/sda1 with the name of your swap partition.

#mount /dev/sda3 /mnt
#Replace /dev/sda3 with the name of your root partition.

#=====================================================================


#else	#for bios
	#echo "Creating BIOS partition";
	#sleep 5
#=====================================================================
#For BIOS

#partition disk
#cfdisk /dev/sda

#Replace /dev/sda2 with the name of your root partition.
#mkfs.ext4 /dev/sda2

#Initialising Swap partition:
#mkswap /dev/sda1
#swapon /dev/sda1
#Replace /dev/sda1 with the name of your swap partition.

#mount /dev/sda2 /mnt
#Replace /dev/sda2 with the name of your root partition.

#=====================================================================

#fi

#read -r -p "Enter block device to install arch onto (press enter for default: sda): " IN_DEVICE
#IN_DEVICE=${IN_DEVICE:-sda}


# NEW partition method
if [ -d /sys/firmware/efi/efivars/ ]; then #for uefi
	echo "Creating UEFI partition";
	sleep 3

#=====================================================================
#For UEFI

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${IN_DEVICE}
  g # create new GPT partition table
  n # new partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M # 512M EFI partition
  t # change partition type
  uefi # to uefi type
  n # new partition
  2 # partition number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  w # write the partition table
  q # quit
EOF

# Set up the partition choices for the install disk
if [[ $IN_DEVICE =~ 'nvme' ]]; then
 #SWAP_DEVICE="${IN_DEVICE}p1"
 EFI_DEVICE="${IN_DEVICE}p1"
 ROOT_DEVICE="${IN_DEVICE}p2"   
else
 #SWAP_DEVICE="${IN_DEVICE}1"
 EFI_DEVICE="${IN_DEVICE}1"
 ROOT_DEVICE="${IN_DEVICE}2"
fi

 
mkfs.fat -F32 "$EFI_DEVICE"
#Replace /dev/sda2 with the name of your EFI System partition.
 
mkfs.ext4 "$ROOT_DEVICE"
#Replace /dev/sda3 with the name of your root partition.
 
#Initialising Swap partition:
#mkswap "$SWAP_DEVICE"
#swapon "$SWAP_DEVICE"
#Replace /dev/sda1 with the name of your swap partition.

mount "$ROOT_DEVICE" /mnt
#Replace /dev/sda3 with the name of your root partition.

#=====================================================================


else	#for bios
	echo "Creating BIOS partition";
	sleep 3
#=====================================================================
#For BIOS

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${IN_DEVICE}
  o # create new MBR partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
    # default - extend partition to end of disk
  a # make bootable
  w # write the partition table
  q # quit
EOF

# Set up the partition choices for the install disk
if [[ $IN_DEVICE =~ 'nvme' ]]; then
 #SWAP_DEVICE="${IN_DEVICE}p1"
 ROOT_DEVICE="${IN_DEVICE}p1" 
else
 #SWAP_DEVICE="${IN_DEVICE}1"
 ROOT_DEVICE="${IN_DEVICE}1"
fi


#Replace /dev/sda2 with the name of your root partition.
mkfs.ext4 "$ROOT_DEVICE"

#Initialising Swap partition:
#mkswap "$SWAP_DEVICE"
#swapon "$SWAP_DEVICE"
#Replace /dev/sda1 with the name of your swap partition.

mount "$ROOT_DEVICE" /mnt
#Replace /dev/sda2 with the name of your root partition.

#=====================================================================
fi

# swap file creation
dd if=/dev/zero of=/mnt/swapfile bs=1M count=$swap status=progress
chmod 600 /mnt/swapfile
mkswap -U clear /mnt/swapfile
swapon /mnt/swapfile
#echo "/swapfile none swap defaults 0 0" >> /mnt/etc/fstab
#echo "vm.swappiness = 110" > /mnt/etc/sysctl.d/99-swappiness.conf

# get fastest mirror, replace with your own country code
#reflector -c "SG" -p https --sort rate --save /mnt/etc/pacman.d/mirrorlist
mv /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist


# install necessary packages	
#pacstrap /mnt base base-devel linux linux-headers linux-firmware nano dhcpcd iwd
#pacstrap /mnt base base-devel linux linux-headers linux-firmware nano dhcpcd
pacstrap /mnt base base-devel linux-lts linux-lts-headers linux-firmware nano dhcpcd

# Generate an fstab config
genfstab -U /mnt >>/mnt/etc/fstab
echo "/swapfile none swap defaults 0 0" >> /mnt/etc/fstab

# copy some config files to /mnt
cp pacman.conf /mnt/etc/pacman.conf
cp locale.gen /mnt/etc/locale.gen
#cp sudoers /mnt/etc/sudoers

#cp time.sh /mnt
cp wine.sh /mnt
cp disk.sh /mnt
cp download.sh /mnt
cp install.sh /mnt
cp others.sh /mnt

# chroot into the new system and run the time.sh script
# arch-chroot /mnt ./time.sh

# set the time zone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime
arch-chroot /mnt hwclock --systohc

# set settings related to locale
 nano /etc/locale.gen

# Uncomment # to include chinese for locale generation
#sudo sed -i 's/^# *\(zh_\)/\1/' /mnt/etc/locale.gen

arch-chroot /mnt locale-gen
echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf

clear

# set hostname
#echo -n "Enter hostname: "
#read -r HOSTNAME
echo "${HOSTNAME}" > /mnt/etc/hostname

# configure hosts file
cat <<EOF >> /mnt/etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    ${HOSTNAME}
EOF

# start dhcp
arch-chroot /mnt systemctl enable dhcpcd
arch-chroot /mnt systemctl start dhcpcd

# set swappiness
echo "vm.swappiness = 110" > /mnt/etc/sysctl.d/99-swappiness.conf

#Set root password
#echo 'Set root password' >&2
#arch-chroot /mnt passwd
echo "root:$NEW_PASSWORD" | arch-chroot /mnt chpasswd  #chpasswd takes the format of changing passwords by (name):(new password)
#echo "setting root passwd"
#sleep 5

#Chaotic-AUR
#pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
arch-chroot /mnt pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
#pacman-key --lsign-key FBA220DFC880C036
arch-chroot /mnt pacman-key --lsign-key FBA220DFC880C036
#pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
arch-chroot /mnt pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo "  " >> /mnt/etc/pacman.conf
echo "[chaotic-aur]" >> /mnt/etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /mnt/etc/pacman.conf

arch-chroot /mnt pacman -Sy

if [ -d /sys/firmware/efi/efivars/ ]; then #for uefi
	echo "Install grub for UEFI";
	
	sleep 3
	
#=====================================================================
#For UEFI

#Installing grub
arch-chroot /mnt pacman -S grub efibootmgr --noconfirm
 
#Making EFI Directory
arch-chroot /mnt mkdir /boot/efi
 
#Mount EFI Partition
arch-chroot /mnt mount "$EFI_DEVICE" /boot/efi
#Replace /dev/sda2 with the name of your EFI System partition
 
arch-chroot /mnt grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi --removable
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

#=====================================================================

#=====================================================================

else	#for bios
	echo "Install grub for BIOS";
	sleep 3
#=====================================================================
#For BIOS

# install and configure grub
arch-chroot /mnt pacman -S grub os-prober --noconfirm
arch-chroot /mnt grub-install ${IN_DEVICE}
#Replace /dev/sda with the drive name on your system
 
#Configuring Bootloader
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

#=====================================================================

fi


# add user
#echo -n "Enter username: "
#read -r USERNAME
arch-chroot /mnt useradd -m ${USERNAME}

# set user password	
#echo 'Set user password' >&2
#arch-chroot /mnt passwd ${USERNAME}
echo "$USERNAME:$NEW_PASSWORD" | arch-chroot /mnt chpasswd  #chpasswd takes the format of changing passwords by (name):(new password)
#echo "setting user passwd"
#sleep 5

arch-chroot /mnt usermod -a -G wheel ${USERNAME}
#nano /mnt/etc/sudoers
#sudo sed -i 's/^# *\(%wheel ALL=(ALL:ALL) ALL\)/\1/' /mnt/etc/sudoers
sudo sed -i 's/^# *\(%wheel ALL=(ALL:ALL) ALL\)/\1/' /mnt/etc/sudoers

# To update System
arch-chroot /mnt pacman -Syyu

case $install_type in

[1]* )
# Intel, AMD or Nvidia
arch-chroot /mnt pacman -S intel-media-driver libva-intel-driver libva-mesa-driver vulkan-intel vulkan-radeon --noconfirm
arch-chroot /mnt pacman -S xf86-video-amdgpu xf86-video-ati xf86-video-nouveau xf86-video-vmware --noconfirm
arch-chroot /mnt pacman -S xf86-video-intel mesa virtualbox-guest-utils --noconfirm ;;

[2]* )
# virtualbox install
arch-chroot /mnt pacman -S virtualbox-guest-utils --noconfirm;;

[3]* )
# qemu install
arch-chroot /mnt pacman -S xf86-video-qxl --noconfirm;;

*)  ;;
esac

	
# X install
arch-chroot /mnt pacman -S xorg xterm xorg-xinit xorg-server --noconfirm

# install pipewire or pulseaudio
case $pipe_install in

[yY]* )
# pipewire install
arch-chroot /mnt pacman -S pipewire pipewire-alsa --noconfirm
arch-chroot /mnt pacman -S wireplumber --noconfirm
arch-chroot /mnt pacman -S pipewire-pulse --noconfirm
arch-chroot /mnt systemctl --global enable pipewire pipewire-pulse wireplumber --noconfirm ;;
#systemctl --user --now enable pipewire pipewire-pulse wireplumber

[nN]* )
# pulseaudio install
arch-chroot /mnt pacman -S pulseaudio pulseaudio-alsa pavucontrol pulseaudio-bluetooth --noconfirm;; #if need bluetooth
#arch-chroot /mnt pacman -S pulseaudio pulseaudio-alsa pavucontrol --noconfirm;; #no bluetooth

*)  ;;
esac

# desktop environment install
# do not install all/many
# budgie and gnome conflict with each other

case $desktop_install in

[1]* )
# cutefish install
arch-chroot /mnt pacman -S cutefish --noconfirm;;

[2]* )
# ukui install
arch-chroot /mnt pacman -S ukui --noconfirm;;

[3]* )
# mate install
arch-chroot /mnt pacman -S mate mate-extra --noconfirm;;

[4]* )
# budgie install
arch-chroot /mnt pacman -S budgie --noconfirm;;

[5]* )
# gnome install
arch-chroot /mnt pacman -S gnome gnome-extra --noconfirm;;

[6]* )
# lxde install
arch-chroot /mnt pacman -S lxde --noconfirm;;

[7]* )
# enlightenment install
arch-chroot /mnt pacman -S enlightenment --noconfirm;;

[8]* )
# xfce install
arch-chroot /mnt pacman -S xfce4 xfce4-goodies --noconfirm;;

[9]* )
# lqxt install
#arch-chroot /mnt pacman -S lxqt breeze-icons --noconfirm;;
arch-chroot /mnt pacman -S lxqt breeze-icons oxygen-icons --noconfirm;;

*)  ;;
esac


# login manager install
arch-chroot /mnt pacman -S lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm

# install wine
# nano /etc/pacman.conf
#arch-chroot /mnt pacman -Syu
#arch-chroot /mnt pacman -S wine wine-mono wine-gecko winetricks --noconfirm
#arch-chroot /mnt wine --version
#winetricks corefonts dotnet40 cjkfonts
#winetricks corefonts cjkfonts

# wine audio support
case $pipe_install in

[yY]* )
# pipewire install
arch-chroot /mnt pacman -S lib32-pipewire pipewire-pulse lib32-libpulse lib32-gnutls --noconfirm;;

[nN]* )
# pulseaudio install
arch-chroot /mnt pacman -S lib32-libpulse lib32-gnutls --noconfirm;; 
*)  ;;
esac

arch-chroot /mnt pacman -S adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-sans-hk-fonts --noconfirm

# install IME and other misc
arch-chroot /mnt pacman -S fcitx5-im fcitx5-chinese-addons --noconfirm	

case $desktop_install in

[3]* )
# mate install
arch-chroot /mnt pacman -S firefox neofetch vlc gst-libav filezilla networkmanager openvpn networkmanager-openvpn nm-connection-editor network-manager-applet cdrtools x11vnc parcellite --noconfirm;;

# others
*) 
# only when mate is not installed, use fuseiso and nemo for mounting iso and alacarte for menu editing
#arch-chroot /mnt pacman -S firefox vlc gst-libav filezilla networkmanager openvpn networkmanager-openvpn nm-connection-editor network-manager-applet dolphin cdemu-daemon cdemu-client alacarte x11vnc parcellite --noconfirm
arch-chroot /mnt pacman -S firefox neofetch vlc gst-libav filezilla networkmanager openvpn networkmanager-openvpn nm-connection-editor network-manager-applet --noconfirm
#arch-chroot /mnt pacman -S fuseiso nemo filemanager-actions cdrtools alacarte x11vnc parcellite --noconfirm;;
arch-chroot /mnt pacman -S fuseiso nemo gnome-clocks gnome-disk-utility cdrtools alacarte x11vnc parcellite  --noconfirm;;
esac



# for qemu
#arch-chroot /mnt pacman -S qemu-desktop --noconfirm

#systemctl disable iwd
arch-chroot /mnt systemctl enable NetworkManager


case $install_type in

[1]* )
# virtualbox install
arch-chroot /mnt systemctl enable vboxservice;;

[2]* )
# virtualbox install
arch-chroot /mnt systemctl enable vboxservice;;

*)  ;;
esac



###### END  ######

if [ -d /sys/firmware/efi/efivars/ ]; then #for uefi
	echo "Shutting down....";
	shutdown now
	
else	#for bios
	echo "Rebooting....";	
    reboot

fi
