# ========== Section 4 ==========
# timezone locale, hostname,
# basic networking and passwd

# Compact license text
printf "\n"
echo "
BSD 3-Clause License

Copyright (c) 2020, Felipe V. Calderan
All rights reserved.

Full license text in part1.sh.
"

# 4.1 retype dev
loadkeys br-abnt2
printf "\nPlease, retype Root Device: "
read dev

# 4.2 prompt
printf "\nNow a list will be presented with all the timezones available,\n"
printf "so be sure to find you own, for example: America/Sao_Paulo.\n"
printf "In the list, use vim keys or arrow keys to scroll and q to quit\n"
read -p "Press any key to continue... " -n 1 -s
timedatectl list-timezones

printf "\nType your timezone how it was in the list: "
read timezonename

printf "\nType a hostname for your system: "
read selectedhostname

# 4.3 timezone and locale (pt_BR.UTF-8)
timedatectl set-timezone $timezonename
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 > /etc/locale.conf
localectl set-locale LANG=pt_BR.UTF-8
echo KEYMAP=br-abnt2 > /etc/vconsole.conf
localectl set-keymap br-abnt2

# 4.4 set host name and basic net
echo $selectedhostname > /etc/hostname
echo "127.0.0.1 localhost" > /etc/hosts
echo "::1   localhost" >> /etc/hosts
echo "127.0.1.1 $selectedhostname" >> /etc/hosts

# 4.5 password
printf "\nRoot password creation.\n"
passwd

# ========== Section 5 ==========
# grub install and configuration
# reboot

# 5.1 grub
printf "\nPackages for the boot loader must be downloaded.\n"
read -p "Press any key to continue... " -n 1 -s

pacman -S grub efibootmgr
mkdir /boot/efi
mount ${dev}1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# 5.2 reboot
printf "\nSystem needs reboot to end the installation."
printf "\nYou must login as \"root\", and after that, if"
printf "\npart3.sh was downloaded, it can be ran. It contains"
printf "\nbasic help for network and user configurations."
printf "\n\nIf Arch fails to boot (Loading initial ramdisk),"
printf "\nrestart the machine and in GRUB select:"
printf "\n-> Advanced options for Arch Linux"
printf "\n and then:"
printf "\n->Arch Linux, with Linux linux (fallback initramfs).\n"
printf "\nPlease type \"exit\"."
