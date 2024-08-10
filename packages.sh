#!/bin/bash

sudo apt install dialog -y

PACKAGES_DIR="packages"

phpactor_install() {
  mkdir -p $PACKAGES_DIR/phpactor
  cd $PACKAGES_DIR/phpactor
  curl -Lo phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
  chmod a+x phpactor.phar
  mv phpactor.phar ~/.local/bin/phpactor
}

neovim_install() {
  mkdir -p $PACKAGES_DIR/neovim
  cd $PACKAGES_DIR/neovim
  wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O ~/.local/bin/nvim
  chmod u+x ~/.local/bin/nvim
  ln -s ~/.local/bin/nvim ~/.local/bin/vim
}

choices=$(dialog --clear \
  --separate-output \
  --backtitle "Install packages" \
  --title "Install selected packages" "$@" \
  --checklist "Please select packages need to install: \n" 50 100 5 \
  1 "docker" ON \
  2 "docker compose" ON \
  3 "vim" OFF \
  4 "nvim" ON \
  5 "mosquitto" OFF \
  6 "ghostwriter" ON \
  7 "phpactor" OFF \
  8 "neovim" ON \
  2>&1 >/dev/tty)

pkg_manager=(sudo apt install -y)

clear

for choise in $choices; do
  case $choise in
  1) ${pkg_manager[@]} docker ;;
  2) ${pkg_manager[@]} docker-compose ;;
  3) ${pkg_manager[@]} vim ;;
  4) ${pkg_manager[@]} nvim ;;
  5) ${pkg_manager[@]} mosquitto ;;
  6) ${pkg_manager[@]} ghostwriter ;;
  7) phpactor_install ;;
  8) neovim_install ;;
  esac
done
