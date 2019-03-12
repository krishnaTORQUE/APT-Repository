#!/bin/bash

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

printf "${bold_txt}Disable NMP ...${normal_txt}\n"

# Disable NMP #
sudo systemctl disable mysql
sudo systemctl disable php7.3-fpm
sudo systemctl disable nginx

# Stop NMP #
sudo systemctl stop mysql
sudo systemctl stop php7.3-fpm
sudo systemctl stop nginx

printf "${bold_txt}Done${normal_txt}\n\n"
