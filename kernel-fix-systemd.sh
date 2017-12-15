#!/bin/bash

MY=$(dirname $(realpath "${0}"))


if $MY/kernel-fix.sh; then
    echo "Kernel updated, rebooting..."
    exit 1
fi
exit 0