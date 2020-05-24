# ========== Section 7 ==========
# GUI config

# Compact license text
printf "\n"
echo "
BSD 3-Clause License

Copyright (c) 2020, Felipe V. Calderan
All rights reserved.

Full license text in part1.sh.
"

printf "\nThis wizard helps installing Awesome Window Manager.\n"
printf "It's user-friendly and doesn't require a lot of configs\n"
printf "to be useful, so you should be able to use the system\n"
printf "normally after this. Also, this wizard supposes you are\n"
printf "logged into your personal sudoer account, so you may\n"
printf "need to insert you password in the next step.\n"
read -p "Press any key to continue... " -n 1 -s

sudo pacman -S xorg-server xorg-apps xorg-xinit xterm awesome noto-fonts libxkbcommon
localectl -set-x11-keymap br

printf "\nWhich of these resolutions better fits you display?\n"
printf "1024x768\n"
printf "1280x800\n"
printf "1360x768\n"
printf "1440x900\n"
printf "1680x1050\n"
printf "1920x1200\n"
printf "2560x1600\n"
printf "Please type: "
read resvar
echo "xrandr -s $resvar" > ~/.xinitrc
echo "setxkbmap br" >> ~/.xinitrc
echo "exec awesome" >> ~/.xinitrc

printf "\nWe are done! Type \"startx\" to enter the GUI\n"
printf "There, type Super+S to get help, or use the menus.\n"
