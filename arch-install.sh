#!/bin/false
# Notes from my arch install, e.g. should I need to re-install
# as this is being done a few days after the fact, my memory
# of any lessons learned may not be perfect

# Beginning naturally largely follows the installation guide
# https://wiki.archlinux.org/index.php/Installation_guide

# confirm UEFI mode is enabled
ls /sys/firmware/efi/efivars
ping archlinux.org
timedatectl set-ntp true

# Prepare for disk encryption
# https://wiki.archlinux.org/index.php/Dm-crypt/Drive_preparation
cryptsetup open --type plain /dev/sda container --key-file /dev/random
fdisk -l # should see /dev/mapper/container
dd if=/dev/zero of=/dev/sda bs=1M status=progress
cryptsetup close container
# LESSON LEARNED - jumped the gun and forgot to close the container the first
# time, resulting in some funky errors

# LVM on LUKS
# https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS
# I initially tried installation following the guide in Pavel Kogan's blog
# http://www.pavelkogan.com/2014/05/23/luks-full-disk-encryption/
# which is referenced in the above wiki article, but was unsuccessful

parted /dev/sda mktable gpt

# LESSON LEARNED - the wiki article explicitly says to use create a BIOS boot partition.
# UEFI being enabled on my laptop, this approach did not work for me, and I followed the
# UEFI systems section instead: https://wiki.archlinux.org/index.php/GRUB#UEFI_systems
# which points further to: https://wiki.archlinux.org/index.php/EFI_System_Partition
gdisk /dev/sda
> n
> 1
> (start) 2048 # default
> (end) +256M
> 8300 # default
# I believe I went ahead at this time to create /dev/sda2 as well
> n
> 2
> (start) 526336 # default
> (end) --- # default, end of disk
> 8300 # default
# save changes
> w
parted /dev/sda
> set 1 boot on
# results:
# Number  Start (sector)    End (sector)  Size       Code  Name
#    1            2048          526335   256.0 MiB   EF00  Linux filesystem
#    2          526336       976773134   465.5 GiB   8300  Linux filesystem

mkfs.fat -F32 /dev/sda1
# LESSON LEARNED - don't forget the -F32
# LESSON LEARNED - the encryption guide from the wiki shows creating an EXT2
# filesystem for the boot partition. I did not find this to work (I forget the
# exact problem encountered at this point)

# This is more or less straight from the wiki
cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 cryptolvm
pvcreate /dev/mapper/cryptolvm
vgcreate rootvg /dev/mapper/cryptolvm
lvcreate -L 4G rootvg -n swap
lvcreate -L 128G rootvg -n root
lvcreate -l 80%FREE rootvg -n home # I like to leave a bit available
mkfs.ext4 /dev/mapper/rootvg-root
mkfs.ext4 /dev/mapper/rootvg-home
mkswap /dev/mapper/rootvg-swap

mount /dev/mapper/rootvg-root /mnt
mkdir -p /mnt/{home,boot}
mount /dev/mapper/rootvg-home /mnt/home
mount /dev/sda1 /mnt/boot
swapon /dev/mapper/rootvg-swap

# installation
pacstrap /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/MyRegios/MyCapital /etc/localtime
hwclock --systohc

# edit this line in /etc/mkinitcpio.conf
HOOKS="base udev autodetect modconf keyboard block encrypt lvm2 filesystems fsck"
# LESSON LEARNED - the order here is important! I had originally appended
# encrypt and lvm2 to the end of the line, which can prevent root from being
# decrypted and mounted
mkinitcpio -p linux

# installing and configuring GRUB
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
# edit this line in /etc/default/grub
GRUB_CMDLINE_LINUX="cryptdevice=UUID=d137025a-8e85-4c57-8ca0-6ca1750e91ed:cryptolvm root=/dev/mapper/rootvg-root resume=/dev/mapper/rootvg-swap"
# LESSON LEARNED - I selected the wrong UUID the first time. This should be the
# UUID of /dev/sda2, not /dev/mapper/cryptolvm or /dev/mapper/rootvg-root
# UUID from ls -l /dev/disk/by-uuid or lsblk -o +UUID
cp /boot/grub/grub.cfg /boot/grub/grub.cfg.bak # not required, but good practice
grub-mkconfig -o /boot/grub/grub.cfg

# uncomment this line in /etc/locale.gen
# en_US.UTF-8 UTF-8
locale-gen

echo 'LANG=en_US.UTF-8' > /etc/locale.conf

echo myhostname > /etc/hostname
echo '127.0.1.1 myhostname.localdomain myhostname' >> /etc/hosts
# or just do this in vi to line it all up

passwd

# if you don't want to be logging in as root all the time
useradd -m newuser
passwd newuser

exit # from the chroot
umount -R /mnt
reboot

# This can only be done after rebooting

# I'm not sure what of this works and what doesn't so
pacman -S ifplugd dialog wpa_supplicant
cd /etc/netctl
cp examples/ethernet-dhcp enp1s0 # or whatever your interface is called
vi enp1s0
systemctl start netctl-ifplugd@enp1s0.service
systemctl enable netctl-ifplugd@enp1s0.service
cp examples/wireless-wpa network-name
vi network-name
# After playing with iw for a long time, I went with wifi-menu instead
# wifi-menu returned an error for me so to fix:
pacman -S rfkill
rfkill unblock wifi
ip link set wlp2s0 down # TODO - I'm really not sure why I have to down the IF
wifi-menu #


## End basic install. Should be able to login after rebooting/decrypting

# I like i3, so that's what I've installed here
# TODO - this needs to be expanded
pacman -S i3-wm i3lock i3status dmenu
pacman -S xorg xorg-xinit
pacman -S rxvt-unicode firefox chromium
pacman -S arc-gtk-theme thunar feh lxappearance
pacman -S tmux vim openssh unzip bind-tools alsa-utils
pacman -S autocutsel
#firefox http://terminus-font.sourceforge.net/
