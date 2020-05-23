# ========== Section 0 ==========
# Welcome Text and set keyboard

# 0.1 Welcome text
printf "Arch Linux Install Script\n"
printf "By Felipe V. Calderan\n\n"

# 0.2 Load BR-ABNT2 keyboard
loadkeys br-abnt2

# ========== Section 1 ==========
# fdisk and format

# 1.1 prompts
lsblk
printf "\nDevice name of TYPE disk (example: sda): "
read device
printf "Swap size (in GB): "
read swapsize

# 1.2 code
dev='/dev/'$device
umount "$dev"

printf "g\nn\n\n\n+512M\nn\n\n\n+${swapsize}G\nn\n\n\n\nt\n1\n1\nt\n2\n19\nt\n3\n24\nw\n" | fdisk "$dev"

mkfs.fat -F32 ${dev}1
mkswap ${dev}2
swapon ${dev}2
mkfs.ext4 ${dev}3

# ========== Section 2 ==========
# pacman mirrors and downloads

# 2.1 prompts
printf "\nWrite the brand of your cpu in lowercase [amd/intel]: "
read cpucode

# 2.2 mirror selection (Brazil)
echo "Server = http://archlinux.c3sl.ufpr.br/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
echo "Server = http://linorg.usp.br/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://archlinux.pop-es.rnp.br/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.ufam.edu.br/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.ufscar.br/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist

# 2.3 mount root and pacstrap
mount ${dev}3 /mnt

pacstrap /mnt base base-devel linux linux-firmware neovim man-db man-pages inetutils netctl dhcpcd ${cpucode}-ucode

# ========== Section 3 ==========
# genfstab, chroot, timezone
# locale, hostname, net and passwd

# 3.1 prompt
printf "\nNow a list will be presented with all the timezones available,\n"
printf "so be sure to find you own, for example: America/Sao_Paulo.\n"
printf "In the list, use vim keys or arrow keys to scroll and q to quit\n"
read -p "Press any key to continue... " -n 1 -s
timedatectl list-timezones

printf "\nNow, type you timezone how it was in the list: "
read timezonename

printf "\nType a hostname for your system: "
read selectedhostname

# 3.2 genfstab and chroot
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# 3.3 timezone and locale (pt_BR.UTF-8)
timedatectl set-timezone $timezonename
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
localectl set-locale LANG=pt_BR.UTF-8
localectl set-keymap br-abnt2

# 3.4 set host name and basic net
echo $selectedhostname > /etc/hostname
echo "127.0.0.1 localhost" > /etc/hosts
echo "::1   localhost" >> /etc/hosts
echo "127.0.1.1 $selectedhostname" >> /etc/hosts

# 3.5 password
printf "\nRoot password creation.\n"
passwd

# ========== Section 4 ==========
# grub install and configuration

printf "\nPackages for the boot loader must be downloaded.\n"
read -p "Press any key to continue... " -n 1 -s

pacman -S grub efibootmgr
mkdir /boot/efi
mount ${dev}1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

printf "\nSystem will be rebooted to end the installation."
read -p "Press any key to continue... " -n 1 -s
shutdown -r now
