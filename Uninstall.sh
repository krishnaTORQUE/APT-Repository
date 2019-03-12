#!/bin/bash

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

printf "${bold_txt}Uninstalling NMP ...${normal_txt}\n"

# Asking for uninstall MySQL #
printf "${bold_txt}Would you like to uninstall MySQL?${normal_txt} [Y/n]: "
read uninstall_mysql

sudo systemctl stop nginx
sudo systemctl stop mysql
sudo systemctl stop php7.3-fpm

sudo chown -R $USER:$USER /var/www
sudo chown -R $USER:$USER /var/www/*
sudo chmod -R u=rwx,g=rwx,o=- /var/www
sudo chmod -R u=rwx,g=rwx,o=- /var/www/*

# Uninstalling MySQL if true #
if [[ $uninstall_mysql = Y ]] || [[ $uninstall_mysql = y ]]; then

    sudo rm -rf /etc/apt/sources.list.d/mysql*
    sudo apt remove --purge mysql* -y
    sudo rm -rf /etc/mysql /var/lib/mysql/*
    sudo rm -rf /etc/mysql /var/lib/mysql
fi

# Remove PPA #
sudo add-apt-repository --remove ppa:nginx/stable -y
sudo add-apt-repository --remove ppa:ondrej/php -y

# Uninstall PHP & Nginx #
sudo apt remove --purge --autoremove php* -y
sudo apt remove --purge --autoremove  nginx* -y

# Remove phpMyAdmin
phpmyadmin_dir='/var/www/html/phpmyadmin'
if [ -d $phpmyadmin_dir ]; then
	rm -rf $phpmyadmin_dir
fi

# Remove Default Index File #
index_debian_file='/var/www/html/index.nginx-debian.html'
if [ -f $index_debian_file ]; then
	rm '/var/www/html/index.nginx-debian.html'
fi

# Remove Info #
nmp_info='/var/www/html/info.php'
if [ -f $nmp_info ]; then
	rm $nmp_info
fi

# Remove Index #
nmp_index='/var/www/html/index.php'
if [ -f $nmp_index ]; then
	rm $nmp_index
fi

# Clearup #
sudo apt autoremove --purge -y
sudo apt autoclean -y
sudo apt remove -y
sudo apt clean -y

printf "${bold_txt}Done${normal_txt}\n\n"
