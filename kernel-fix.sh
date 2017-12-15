#!/bin/bash

MY=$(dirname $(realpath "${0}"))
source $MY/kernel-fix-lib.sh

###########################################################
## Install current kernel's modules.
###########################################################

print_kernel_info

if ! kernel_fix_needed; then
    echo -e "${GREEN}No fix needed, exiting.${RESET}"
    exit 1
fi

echo "Installing..."

sudo pacman -Udd --noconfirm "${KPKGFILE}"

###########################################################
## Mount boot.
###########################################################
if ! mount_boot; then
    echo -e "${RED}Could not mount any boot partitions, exiting!${RESET}"
    exit 2
fi

###########################################################
## Update kernel.
###########################################################
sudo pacman -S --noconfirm linux

if [ $(ls -1 /boot-vbox | wc -l) -eq 0 ]; then
  echo "Virtualbox boot partition NOT present, skipping."
else
  echo "Virtualbox boot partition present."
  if ! cmp -s /boot{,-vbox}/vmlinuz-linux || \
     ! cmp -s /boot{,-vbox}/initramfs-linux.img; then
    echo "Updating virtualbox boot partition..."
    sudo cp -rav /boot/* /boot-vbox/
  fi
fi

if [ $(ls -1 /boot-native | wc -l) -eq 0 ]; then
  echo "Native boot partition NOT present, skipping."
else
  echo "Native boot partition present."
  if ! cmp -s /boot{,-native}/vmlinuz-linux || \
     ! cmp -s /boot{,-native}/initramfs-linux.img; then
    echo "Updating native boot partition..."
    sudo cp -rav /boot/* /boot-native/
  fi
fi

exit 0

# /boot-native
#mountpoint /boot-vbox/; echo $?

#cmp -s /boot{,-vbox}/vmlinuz-linux; echo $?

#sudo cp -rav /boot/* /boot-vbox/
