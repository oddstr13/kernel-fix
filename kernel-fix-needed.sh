#!/bin/bash

MY=$(dirname $(realpath "${0}"))
source $MY/kernel-fix-lib.sh

print_kernel_info

if kernel_fix_needed; then
    exit 0
else
    exit 1
fi