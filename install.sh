#!/bin/bash

MY=$(dirname $(realpath "${0}"))

sudo cp kernel-fix.service /etc/systemd/system/

sudo sed -i "s|{MYPATH}|${MY}|g" /etc/systemd/system/kernel-fix.service

sudo systemctl daemon-reload
sudo systemctl enable kernel-fix