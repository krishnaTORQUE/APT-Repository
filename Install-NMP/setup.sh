#!/bin/bash

# Installing NGINX MYSQL PHP (NMP)
# Version: 1.0
# Update: 04/05/2018 09:10PM (UTC+5:30) 

# NOTE:
#	Require Internet

# Installing:
# 			Nginx (Latest)
# 			PHP 7.2
# 			Mysql 5.7
# 			phpMyAdmin 4.8 (by User)

printf "
 ___ _   _ ____ _____  _    _     _     
|_ _| \ | / ___|_   _|/ \  | |   | |    
 | ||  \| \___ \ | | / _ \ | |   | |    
 | || |\  |___) || |/ ___ \| |___| |___ 
|___|_| \_|____/ |_/_/   \_|_____|_____|
	 _   _ __  __ ____  
	| \ | |  \/  |  _ \ 
	|  \| | |\/| | |_) |
	| |\  | |  | |  __/ 
	|_| \_|_|  |_|_|    

		Verion: 1.0

"

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

# Asking user to install phpMyAdmin
printf "${bold_txt}Would you like to use phpMyAdmin?${normal_txt} [Y/n]: "
read install_phpmyadmin

function chdir_owner() {
	sudo chown -R $USER:www-data /var/www
	sudo chown -R $USER:www-data /var/www/*
	sudo chmod -R u=rwx,g=rwx,o=- /var/www
	sudo chmod -R u=rwx,g=rwx,o=- /var/www/*
}

printf "${bold_txt}Processing ...\n${normal_txt}"
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:nginx/stable
sudo add-apt-repository ppa:ondrej/php

printf "${bold_txt}Updating ...\n${normal_txt}"
sudo apt-get update -y
sudo apt-get upgrade -y

printf "${bold_txt}Installing Nginx ...\n${normal_txt}"
sudo apt-get install nginx -y
sudo cp $SCRIPTPATH/files/nginx-default /etc/nginx/sites-available/default
sudo chown root:root /etc/nginx/sites-available/default

printf "${bold_txt}Nginx Installed \nInstalling PHP ...\n${normal_txt}"
sudo apt-get install php7.2-fpm -y
sudo apt-get install php7.2-mysql php7.2-curl php7.2-json php7.2-gd libssh2-1 php-ssh2 php7.2-mbstring php7.2-zip php-xml php-xmlrpc -y
sudo cp $SCRIPTPATH/files/php.ini /etc/php/7.2/fpm/php.ini
sudo chown root:root /etc/php/7.2/fpm/php.ini

printf "${bold_txt}PHP Installed \nInstalling Mysql ...\n${normal_txt}"
sudo apt-get install mysql-server -y
sudo mysql_secure_installation

printf "${bold_txt}Mysql Installed \nConfiguring NMP ...\n${normal_txt}"

chdir_owner

# Installing phpMyAdmin if true
if [[ $install_phpmyadmin = Y ]] || [[ $install_phpmyadmin = y ]]; then
	phpmyadmin_dir='/var/www/html/phpmyadmin'
	if [ -d $phpmyadmin_dir ]; then
		rm -rf $phpmyadmin_dir
	fi
	mkdir $phpmyadmin_dir
	cp -a $SCRIPTPATH/phpmyadmin/* $phpmyadmin_dir
fi

rm '/var/www/html/index.nginx-debian.html'
cp $SCRIPTPATH/files/info.php /var/www/html/info.php
cp $SCRIPTPATH/files/index.php /var/www/html/index.php

chdir_owner

sudo ufw enable
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 80
sudo ufw allow 443

sudo systemctl restart mysql
sudo systemctl restart php
sudo systemctl restart nginx

printf "${bold_txt}Configuring Complete. \n${normal_txt}"
sudo ufw status
sudo ufw app list
nginx -v
php -v
mysql --V
printf "${bold_txt}NMP Installed.\n${normal_txt}"
