#!/bin/bash

# Stop NGINX MYSQL PHP
# NMP Version: 1.9

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

printf "${bold_txt}Please Wait ...${normal_txt}\n"

sudo systemctl stop nginx
sudo systemctl stop mysql
sudo systemctl stop php7.2-fpm

printf "${bold_txt}NMP Stopped${normal_txt}\n\n"
