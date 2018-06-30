#!/bin/bash

# Restart NGINX MYSQL PHP
# NMP Version: 1.6

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

printf "${bold_txt}Restarting NMP ...${normal_txt}\n"

sudo systemctl restart mysql
sudo systemctl restart php7.2-fpm
sudo systemctl restart nginx
sudo chown -R $USER:www-data /var/www && sudo chown -R $USER:www-data /var/www/*
sudo chmod -R u=rwx,g=rwx,o=- /var/www && sudo chmod -R u=rwx,g=rwx,o=- /var/www/*

printf "${bold_txt}Done${normal_txt}\n\n"
