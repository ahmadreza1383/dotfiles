#!/bin/bash

# Config created by Keyitdev https://www.github.com/keyitdev/dotfiles
# Copyright (C) 2022 Keyitdev

config_directory="$HOME/.config"
fonts_directory="/usr/share/fonts"
scripts_directory="/usr/local/bin"
gtk_theme_directory="/usr/share/themes"

green='\033[0;32m'
no_color='\033[0m'
date=$(date +%s)

sudo apt install dialog -y

system_update() {
  echo -e "${green}[*] Doing a system update, cause stuff may break if it's not the latest version...${no_color}"

  sudo apt upgrade -y
  sudo apt install wget git curl -y
}
install_pkgs() {
  echo -e "${green}[*] Installing packages with pacman.${no_color}"
  sudo apt install -y acpi alsa-utils curl git pulseaudio xorg alacritty btop dunst feh mpc mpd ncmpcpp nemo neofetch papirus-icon-theme picom polybar ranger rofi scrot slop xclip zathura zsh i3 firefox-esr zathura-pdf-poppler
  #### Added by ahmadreza1383
  exec ./packages.sh
  #sudo apt install docker docker-compose
  # Temporary without packages:
  # base-devel
  # pulseaudio-alsa
  # xorg-init
  # code
  # i3-gaps # installed
  # libnotify
  # pacman-contrib
  # zathura-pdf-mupdf
  # firefox # installed
}
install_oh_my_zsh() {
  echo -e "${green}[*] Installing packages with $aurhelper.${no_color}"
  # Temporary commented
  # "$aurhelper" -S --noconfirm --needed light i3lock-color i3-resurrect ffcast oh-my-zsh-git
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}
create_default_directories() {
  echo -e "${green}[*] Copying configs to $config_directory.${no_color}"
  mkdir -p "$HOME"/.config
  sudo mkdir -p /usr/local/bin
  sudo mkdir -p /usr/share/themes
  mkdir -p "$HOME"/Pictures/wallpapers
}
create_backup() {
  echo -e "${green}[*] Creating backup of existing configs.${no_color}"
  [ -d "$config_directory"/alacritty ] && mv "$config_directory"/alacritty "$config_directory"/alacritty_$date && echo "alacritty configs detected, backing up."
  [ -d "$config_directory"/btop ] && mv "$config_directory"/btop "$config_directory"/btop_$date && echo "btop configs detected, backing up."
  [ -d "$config_directory"/dunst ] && mv "$config_directory"/dunst "$config_directory"/dunst_$date && echo "dunst configs detected, backing up."
  [ -d "$config_directory"/gtk-3.0 ] && mv "$config_directory"/gtk-3.0 "$config_directory"/gtk-3.0_$date && echo "gtk-3.0 configs detected, backing up."
  [ -d "$config_directory"/i3 ] && mv "$config_directory"/i3 "$config_directory"/i3_$date && echo "i3 configs detected, backing up."
  [ -d "$config_directory"/mpd ] && mv "$config_directory"/mpd "$config_directory"/mpd_$date && echo "mpd configs detected, backing up."
  [ -d "$config_directory"/ncmpcpp ] && mv "$config_directory"/ncmpcpp "$config_directory"/ncmpcpp_$date && echo "ncmpcpp configs detected, backing up."
  [ -d "$config_directory"/neofetch ] && mv "$config_directory"/neofetch "$config_directory"/neofetch_$date && echo "neofetch configs detected, backing up."
  [ -d "$config_directory"/nvim ] && mv "$config_directory"/nvim "$config_directory"/nvim_$date && echo "nvim configs detected, backing up."
  [ -d "$config_directory"/picom ] && mv "$config_directory"/picom "$config_directory"/picom_$date && echo "picom configs detected, backing up."
  [ -d "$config_directory"/polybar ] && mv "$config_directory"/polybar "$config_directory"/polybar_$date && echo "polybar configs detected, backing up."
  [ -d "$config_directory"/ranger ] && mv "$config_directory"/ranger "$config_directory"/ranger_$date && echo "ranger configs detected, backing up."
  [ -d "$config_directory"/rofi ] && mv "$config_directory"/rofi "$config_directory"/rofi_$date && echo "rofi configs detected, backing up."
  [ -d "$config_directory"/zathura ] && mv "$config_directory"/zathura "$config_directory"/zathura_$date && echo "zathura configs detected, backing up."

  [ -d "$scripts_directory" ] && sudo mv "$scripts_directory" "$scripts_directory"_$date && echo "scripts ($scripts_directory) detected, backing up."

  [ -f "$config_directory"/Code\ -\ OSS/User/settings.json ] && mv "$config_directory"/Code\ -\ OSS/User/settings.json "$config_directory"/Code\ -\ OSS/User/settings.json_$date && echo "Vsc configs detected, backing up."

  [ -f /etc/fonts/local.conf ] && sudo mv /etc/fonts/local.conf /etc/fonts/local.conf_$date && echo "Fonts configs detected, backing up."
}
copy_configs() {
  echo -e "${green}[*] Copying configs to $config_directory.${no_color}"
  cp -r ./config/* "$config_directory"
}
copy_scripts() {
  echo -e "${green}[*] Copying scripts to $scripts_directory.${no_color}"
  sudo cp -r ./scripts/* "$scripts_directory"
}
copy_fonts() {
  echo -e "${green}[*] Copying fonts to $fonts_directory.${no_color}"
  sudo cp -r ./fonts/* "$fonts_directory"
  fc-cache -fv
}
copy_other_configs() {

  echo -e "${green}[*] Copying wallpapers to "$HOME"/Pictures/wallpapers.${no_color}"
  cp -r ./wallpapers/* "$HOME"/Pictures/wallpapers
  echo -e "${green}[*] Copying zsh configs.${no_color}"
  sudo cp ./keyitdev.zsh-theme /usr/share/oh-my-zsh/custom/themes
  cp ./.zshrc "$HOME"
}
install_additional_pkgs() {
  echo -e "${green}[*] Installing additional packages with apt"
  sudo apt install -y dhcpcd gimp iwd libreoffice ntfs-3g ntp pulsemixer vnstat
}
install_emoji_fonts() {
  echo -e "${green}[*] Installing emoji fonts with apt"
  sudo apt install -y noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
  sudo cp -f ./local.conf /etc/fonts
  fc-cache -fv
}
install_vsc() {
  echo -e "${green}[*] Installing vsc extensions.${no_color}"
  code --install-extension zhuangtongfa.Material-theme
  echo -e "${green}[*] Copying vsc configs.${no_color}"
  cp ./vsc/settings.json "$HOME"/.config/Code\ -\ OSS/User
}
install_gtk_theme() {
  echo -e "${green}[*] Installing gtk theme.${no_color}"
  git clone --depth 1 https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme
  echo -e "${green}[*] Copying gtk theme to /usr/share/themes.${no_color}"
  sudo cp -r ./Rose-Pine-GTK-Theme/themes/RosePine-Main-BL /usr/share/themes/RosePine-Main
  mkdir -p "$HOME"/.config/gtk-4.0
  sudo cp -r ./Rose-Pine-GTK-Theme/themes/RosePine-Main-BL/gtk-4.0/* "$HOME"/.config/gtk-4.0
}
install_sddm() {
  echo -e "${green}[*] Installing sddm theme.${no_color}"
  sudo apt install -y sddm libqt5svg5-dev/stable libqt5svg5/stable qml-module-qtgraphicaleffects/stable qtquickcontrols2-5-dev/stable libqt5quickcontrols2-5/stable
  #sudo apt install -y qt5-graphicaleffects qt5-quickcontrols2 qt5-svg sddm
  sudo systemctl enable sddm.service
  sudo git clone https://github.com/keyitdev/sddm-flower-theme.git /usr/share/sddm/themes/sddm-flower-theme
  sudo cp /usr/share/sddm/themes/sddm-flower-theme/Fonts/* /usr/share/fonts/
  echo "[Theme]
    Current=sddm-flower-theme" | sudo tee /etc/sddm.conf
}
finishing() {
  echo -e "${green}[*] Chmoding light.${no_color}"
  sudo chmod +s /usr/bin/light
  echo -e "${green}[*] Setting Zsh as default shell.${no_color}"
  chsh -s /bin/zsh
  sudo chsh -s /bin/zsh
  echo -e "${green}[*] Updating nvim extensions.${no_color}"
  nvim +PackerSync
}

cmd=(dialog --clear --separate-output --checklist "Select (with space) what script should do.\\nChecked options are required for proper installation, do not uncheck them if you do not know what you are doing." 26 86 16)
options=(1 "System update" on
  2 "Install basic packages" on
  3 "Install oh my zsh" on
  4 "Create default directories" on
  5 "Create backup of existing configs (to prevent overwritting)" on
  6 "Copy configs" on
  7 "Copy scripts" on
  8 "Copy fonts" on
  9 "Copy other configs (gtk theme, wallpaper, vsc configs, zsh configs)" on
  10 "Install additional packages" off
  11 "Install emoji fonts" off
  12 "Install vsc theme" on
  13 "Install gtk theme" on
  14 "Install sddm with flower theme" off
  15 "Make Light executable, set zsh as default shell, update nvim extensions." on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

clear

for choice in $choices; do
  case $choice in
  1) system_update ;;
  2) install_pkgs ;;
  3) install_oh_my_zsh ;;
  4) create_default_directories ;;
  5) create_backup ;;
  6) copy_configs ;;
  7) copy_scripts ;;
  8) copy_fonts ;;
  9) copy_other_configs ;;
  10) install_additional_pkgs ;;
  11) install_emoji_fonts ;;
  12) install_vsc ;;
  13) install_gtk_theme ;;
  14) install_sddm ;;
  15) finishing ;;
  esac
done
