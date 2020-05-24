# ========== Section 6 ==========
# basic network and user configs

# Compact license text
printf "\n"
echo "
BSD 3-Clause License

Copyright (c) 2020, Felipe V. Calderan
All rights reserved.

Full license text in part1.sh.
"

# 6.1 Network configuration
printf "\n=== Network configuration ===\n"
ip address
printf "\nAbove, there's a list of your network adapters.\n"
printf "Type the name of you ethernet/wifi/vbox adapter.\n"
printf "Not \"lo\", but something like \"enp0s3\".\n"
printf ">>> "
read adaptername
systemctl enable dhcpcd@${adaptername}

# 6.2 User configuration
printf "\n=== User configuration ===\n"
printf "\nType a name for your personal user: "
read personaluser

useradd -m -g users -s /bin/bash $personaluser

printf "\nType a password for your user:\n"
passwd $personaluser

echo "root ALL=(ALL) ALL" > /etc/sudoers
echo "$personaluser ALL=(ALL) ALL" >> /etc/sudoers
echo "#includedir /etc/sudoers.d" >> /etc/sudoers

# 6.3 reboot
printf "\nThis was the last step for the archlinux install.\n"
printf "After the reboot, you should have working internet,\n"
printf "and can login into your personal user.\n"
printf "There's another optional step (archinstaller/part4.sh)\n"
printf "to configure a GUI. You may try it after the reboot.\n"
printf "System will now be rebooted\n"
read -p "Press any key to continue... " -n 1 -s
shutdown -r now
