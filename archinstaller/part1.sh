# ========== Section 0 ==========
# Welcome Text and set keyboard

# 0.1 Compact license text and warnings
echo "
BSD 3-Clause License

Copyright (c) 2020, Felipe V. Calderan
All rights reserved.

Full license text in download file.
"

printf "\nThis installer supposes you are Brazilian and running UEFI.\n\n"

# 0.2 Load br-abnt2 keyboard
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
# genfstab, chroot

# 3.1 important information
printf "\nPart 1 is done! Now, run part2.sh."
printf "\nPlease, take note of the Root Device name: $dev"
printf "\nIt'll need to be retyped as soon as part 2 is ran."

# 3.2 genfstab and chroot
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
