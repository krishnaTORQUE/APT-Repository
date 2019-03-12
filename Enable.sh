#!/bin/bash

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

printf "${bold_txt}Enable NMP ...${normal_txt}\n"

# Enable NMP #
sudo systemctl enable mysql
sudo systemctl enable php7.3-fpm
sudo systemctl enable nginx

# Restart NMP #
sudo systemctl restart mysql
sudo systemctl restart php7.3-fpm
sudo systemctl restart nginx

printf "${bold_txt}Done${normal_txt}\n\n"
