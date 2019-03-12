#!/bin/bash

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

printf "${bold_txt}Please Wait ...${normal_txt}\n"

# Stop NMP #
sudo systemctl stop nginx
sudo systemctl stop mysql
sudo systemctl stop php7.3-fpm

printf "${bold_txt}NMP Stopped${normal_txt}\n\n"
