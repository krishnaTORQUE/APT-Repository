#!/bin/bash

# Uninstall NGINX MYSQL PHP
# NMP Version: 1.9

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

printf "${bold_txt}Uninstalling NMP ...${normal_txt}\n"

sudo systemctl stop nginx
sudo systemctl stop mysql
sudo systemctl stop php7.2-fpm

sudo add-apt-repository --remove ppa:nginx/stable -y
sudo add-apt-repository --remove ppa:ondrej/php -y
sudo rm -rf /etc/apt/sources.list.d/mysql*

sudo apt purge --remove php* -y
sudo apt purge --remove nginx* -y
sudo apt purge --remove mysql* -y
sudo rm -rf /etc/mysql /var/lib/mysql

phpmyadmin_dir='/var/www/html/phpmyadmin'
if [ -d $phpmyadmin_dir ]; then
	rm -rf $phpmyadmin_dir
fi

index_debian_file='/var/www/html/index.nginx-debian.html'
if [ -f $index_debian_file ]; then
	rm '/var/www/html/index.nginx-debian.html'
fi

nmp_info='/var/www/html/info.php'
if [ -f $nmp_info ]; then
	rm $nmp_info
fi

nmp_index='/var/www/html/index.php'
if [ -f $nmp_index ]; then
	rm $nmp_index
fi

sudo apt autoclean -y
sudo apt autoclean -y

printf "${bold_txt}Done${normal_txt}\n\n"
