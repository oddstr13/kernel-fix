#!/bin/bash

KERNEL=$(uname -r | awk -F'-' '{print $1}')

#pacaur -U $(ls -1 /var/cache/pacman/pkg/linux-[0-9.]* | tail -n 2 | head -n 1)
KPKGFILE=$(ls -1 /var/cache/pacman/pkg/linux-${KERNEL}-* 2>/dev/null | head -n 1)

KMODDIR=$(ls -1d /usr/lib/modules/${KERNEL}-* | head -n 1)

RED="\033[0;31m"
GREEN="\033[0;32m"
RESET="\033[0m"

function kernel_fix_needed {
    if [ -z "${KMODDIR}" ]; then
        return 0
    else
        return 1
    fi
}

function print_kernel_info {
    echo "Currently running kernel: ${KERNEL}"
    echo "Package file is: ${KPKGFILE}"
    echo "Module directory is: ${KMODDIR}"

    if kernel_fix_needed; then
        echo -e "${RED}Fix needed!${RESET}"
    else
        echo -e "${GREEN}No fix needed.${RESET}"
    fi
}

function is_virtualbox {
    if [[ "$(systemd-detect-virt)" -eq "oracle" ]]; then
        return 0
    else
        return 1
    fi
}

function mount_boot {
    if is_virtualbox; then
        if [ $(ls -1 /boot-vbox | wc -l) -eq 0 ]; then
            echo -n "Mounting VirtualBox boot partition... "

            sudo mount /boot-vbox

            if ! [ $(ls -1 /boot-vbox | wc -l) -neq 0 ]; then
                echo -e "[${GREEN}OK${RESET}]"
                return 0
            else
                echo -e "[${RED}ERR${RESET}]"
                return 1
            fi
        else
            return 0
        fi
    else
        if [ $(ls -1 /boot-native | wc -l) -eq 0 ]; then
            echo -n "Mounting native boot partition... "
            
            sudo mount /boot-native

            if ! [ $(ls -1 /boot-vbox | wc -l) -neq 0 ]; then
                echo -e "[${GREEN}OK${RESET}]"
                return 0
            else
                echo -e "[${RED}ERR${RESET}]"
                return 1
            fi
        else
            return 0
        fi
    fi
}


