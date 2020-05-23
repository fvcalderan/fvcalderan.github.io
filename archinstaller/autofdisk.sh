printf "Arch Linux Install Script\n"
printf "By Felipe V. Calderan\n\n"
lsblk
printf "\nDevice name of TYPE disk (example: sda): "
read device
dev='/dev/'$device
printf "dev: ${dev}\n"
printf "Swap size (in GB): "
read swapsize
umount "$dev"
printf "g\nn\n\n\n+512\nn\n\n\n+${swapsize}G\nn\n\n\n\nt\n1\n1\nt\n2\n19\nt\n3\n24\nw\n" | fdisk "$dev"
