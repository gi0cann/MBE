#!/bin/bash

#########################################
#           Install Tools
#########################################

# install pip packages
function install_pip2s {
  python3 -m pip install --upgrade pip
  python3 -m pip install --upgrade requests
  python3 -m pip install --upgrade colorama
  python3 -m pip install --upgrade pwntools
  python3 -m pip install docopt capstone ropgadget libformatstr xortool
  # capstone is weird
  cp /usr/local/lib/python3.10/dist-packages/usr/lib/python3.10/dist-packages/capstone/libcapstone.so /usr/lib/libcapstone.so.3
  # patch pwntools in a terrible way
  if [ `uname -i` == 'i686' ]; then
      sed -i 's/platform\.machine()/"i386"/' /usr/local/lib/python2.7/dist-packages/pwnlib/asm.py
  fi
}
export -f install_pip2s

# setup gdb PEDA
function install_gdb_peda {
  OPWD=$PWD
  # remove gdb if it exists on this system
  cd $TOOLS_DIR
  git clone https://github.com/longld/peda.git $TOOLS_DIR/peda
  mkdir -p $SKEL_LINK_DIR
  touch $GDBINIT
  echo "source $TOOLS_DIR/peda/peda.py" >> $GDBINIT
  echo "[+] Installed gdb PEDA!"
  cd $OPWD
}
export -f install_gdb_peda

# setup checksec
function install_checksec {
  OPWD=$PWD
  cd /usr/local/bin
  wget https://github.com/slimm609/checksec.sh/raw/master/checksec -O checksec
  chmod +x checksec
  echo "[+] Installed checksec!"
  cd $OPWD
}
export -f install_checksec

# setup radare2
function install_radare2 {
  OPWD=$PWD
  cd $TOOLS_DIR
  sudo -u $REALUSER git clone https://github.com/radare/radare2.git
  cd radare2
  sudo -u $REALUSER ./sys/install.sh
  echo "[+] Installed radare2!"
  cd $OPWD
}
export -f install_radare2

# setup fixenv
function install_fixenv {
  OPWD=$PWD
  cd /tmp
  git clone https://github.com/hellman/fixenv.git
  mv ./fixenv/r.sh /usr/local/bin/fixenv
  chmod +x /usr/local/bin/fixenv
  rm -rf /tmp/fixenv
  echo "[+] Installed fixenv!"
  cd $OPWD
}
export -f install_fixenv

# setup shtest
function install_shtest {
  OPWD=$PWD
  cd /tmp
  git clone https://github.com/hellman/shtest.git
  cd shtest
  gcc -Wall -m32 shtest.c -o shtest
  mv shtest /usr/local/bin/shtest
  cd ..
  rm -rf shtest
  echo "[+] Installed shtest!"
  cd $OPWD
}
export -f install_shtest
