# ========== Section 0 ==========
# Welcome Text and set keyboard

# 0.1 Full license text and warnings
echo "
BSD 3-Clause License

Copyright (c) 2020, Felipe V. Calderan
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
printf "\n\nName of the in-terminal editor you want [vim/neovim/nano]: "
read editorname
printf "\nBrand of your cpu in lowercase [amd/intel]: "
read cpucode

# 2.2 mirror selection (Brazil)
echo "Server = http://archlinux.c3sl.ufpr.br/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
echo "Server = http://linorg.usp.br/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://archlinux.pop-es.rnp.br/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.ufam.edu.br/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.ufscar.br/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist

# 2.3 mount root and pacstrap
mount ${dev}3 /mnt

pacstrap /mnt base base-devel linux linux-firmware $editorname wget man-db man-pages inetutils netctl dhcpcd ${cpucode}-ucode

# ========== Section 3 ==========
# genfstab, chroot

# 3.1 important information
printf "\n\npart1 is done! Download part2 and part3 from\n"
printf "/archinstall/part2.sh and /archinstall/part3.sh"
printf "Please, take note of the Root Device name: $dev"
printf "\nIt'll need to be retyped as soon as part 2 is ran.\n"

# 3.2 genfstab and chroot
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
shutdown -r now
