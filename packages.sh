#!/bin/bash

sudo apt install dialog -y

PACKAGES_DIR="packages"

phpactor_install() {
  ## install php | if not exist
  if wget https://www.php.net/distributions/php-8.3.10.tar.gz -P ~/Downloads/; then
    sudo apt install libxml2-dev sqlite3 libsqlite3-dev libssl-dev
    tar ~/Downloads/php-8.3.10.tar.gz
    cd ~/Downloads/php-8.3.10
    if ./configure --with-zlib --with-openssl; then
      if make; then
        sudo make install
      fi
    fi
  fi

  ###
  mkdir -p $PACKAGES_DIR/phpactor
  cd $PACKAGES_DIR/phpactor
  if curl -Lo phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar; then
    chmod a+x phpactor.phar
    mv phpactor.phar ~/.local/bin/phpactor
  fi
}

neovim_install() {
  mkdir -p $PACKAGES_DIR/neovim
  cd $PACKAGES_DIR/neovim
  wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O ~/.local/bin/nvim
  chmod u+x ~/.local/bin/nvim
  ln -s ~/.local/bin/nvim ~/.local/bin/vim
}

composer_install() {
  php -v || exit 1
  ##
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  ##
  sudo mv composer.phar /usr/local/bin/composer
}

nekoray_install() {
  NEKORAY_FILE=nekoray-3.26-2023-12-09-linux-x64.AppImage
  if [ ! -f ./$NEKORAY_FILE ]; then
    wget https://github.com/MatsuriDayo/nekoray/releases/download/3.26/ || exit 1
  fi

  cp $NEKORAY_FILE ~/.local/bin/nekoray
  chmod 777 ~/.local/bin/nekoray
  NEKORAY_DESKTOP_PATH=~/.local/share/applications/nekoray.desktop
  if [ ! -f $NEKORAY_DESKTOP_PATH ]; then
    echo "
      [Desktop Entry]
      Name=nekoray
      Comment=nekoray
      Exec=$HOME/.local/bin/nekoray
      #Icon=/opt/nekoray/nekoray.png
      Terminal=false
      Type=Application
      Categories=Network;Application;
    " >$NEKORAY_DESKTOP_PATH
  fi
}

qemu_install() {
  echo "Installing qemu"
  sudo apt install -y qemu-utils virt-manager qemu-system || (echo "Apt cannot install qemu! " && exit 1)
  sudo usermod -aG libvirt,libvirt-qemu $USER || (echo "$USER cannot add to libvirt-qemu and libvirt groups" && exit 1)
  echo "qemu and virtual manager is installed"
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
  9 "net-tools" ON \
  10 "composer" OFF \
  11 "nekoray" OFF \
  12 "qemu & virtual manager (GUI)" OFF \
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
  9) ${pkg_manager[@]} net-tools ;;
  10) composer_install ;;
  11) nekoray_install ;;
  12) qemu_install ;;
  esac
done
