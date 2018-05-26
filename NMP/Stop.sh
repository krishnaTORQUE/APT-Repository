#!/bin/bash

# Stop NGINX MYSQL PHP
# NMP Version: 1.5

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

sudo systemctl stop nginx
sudo systemctl stop mysql
sudo systemctl stop php7.2-fpm

printf "${bold_txt}NMP Stopped${normal_txt}\n"
