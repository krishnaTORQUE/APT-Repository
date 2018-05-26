#!/bin/bash

# Installing NGINX MYSQL PHP
# NMP Version: 1.5

# NOTE:
#	Require Internet

# Installing:
# 			Nginx (Latest)
# 			PHP 7.2
# 			Mysql 5.7 / 8.0 (by User)
# 			phpMyAdmin 4.8.1 (by User)

# Configuring:
#			Default Upload File Size 100 MB
#			Default Upload Filers 100

printf "
	 _   _ __  __ ____  
	| \ | |  \/  |  _ \ 
	|  \| | |\/| | |_) |
	| |\  | |  | |  __/ 
	|_| \_|_|  |_|_|    

            Verion: 1.5

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

printf "${bold_txt}\nProcessing ...\n${normal_txt}"
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:nginx/stable -y
sudo add-apt-repository ppa:ondrej/php -y
wget -P /tmp https://repo.mysql.com//mysql-apt-config_0.8.10-1_all.deb
sudo dpkg -i /tmp/mysql-apt-config_0.8.10-1_all.deb

printf "${bold_txt}\nUpdating ...\n${normal_txt}"
sudo apt-get update -y
sudo apt-get upgrade -y

printf "${bold_txt}\nInstalling Nginx ...\n${normal_txt}"
sudo apt-get install nginx -y

printf "${bold_txt}Nginx Installed \n\nInstalling PHP ...\n${normal_txt}"
sudo apt-get install php7.2-fpm -y
sudo apt-get install php7.2-mysql php7.2-curl php7.2-json php7.2-gd libssh2-1 php-ssh2 php7.2-mbstring php7.2-zip php-xml php-xmlrpc -y

printf "${bold_txt}PHP Installed \n\nInstalling Mysql ...\n${normal_txt}"
sudo apt-get install mysql-server -y

printf "${bold_txt}Mysql Installed\n${normal_txt}"

# ================
# ReConfigure NMP
# ================

printf "${bold_txt}\nConfiguring NMP ...\n${normal_txt}"
chdir_owner

# Configure Nginx
sudo cp $SCRIPTPATH/files/nginx-default /etc/nginx/sites-available/default
sudo chown root:root /etc/nginx/sites-available/default
sudo cp $SCRIPTPATH/files/nginx.conf /etc/nginx/nginx.conf
sudo chown root:root /etc/nginx/nginx.conf

# Configure PHP
sudo cp $SCRIPTPATH/files/php.ini /etc/php/7.2/fpm/php.ini
sudo chown root:root /etc/php/7.2/fpm/php.ini

# Configure Mysql
sudo mysql_secure_installation

# Installing phpMyAdmin if true
if [[ $install_phpmyadmin = Y ]] || [[ $install_phpmyadmin = y ]]; then

	sudo rm -rf /tmp/phpMyAdmin*
	wget -P /tmp https://files.phpmyadmin.net/phpMyAdmin/4.8.1/phpMyAdmin-4.8.1-english.zip
	unzip /tmp/phpMyAdmin-4.8.1-english.zip -d /tmp

	phpmyadmin_dir='/var/www/html/phpmyadmin'
	if [ -d $phpmyadmin_dir ]; then
		rm -rf $phpmyadmin_dir
	fi
	mkdir $phpmyadmin_dir
	cp -rf /tmp/phpMyAdmin-4.8.1-english/. $phpmyadmin_dir

	rm -rf /tmp/phpMyAdmin*
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

cp $SCRIPTPATH/files/info.php /var/www/html/info.php
cp $SCRIPTPATH/files/index.php /var/www/html/index.php

rm /tmp/mysql-apt-config_0.8.10-1_all.deb

chdir_owner

sudo ufw enable
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 80
sudo ufw allow 443

printf "${bold_txt}\nConfiguring Complete. \n${normal_txt}"

sudo systemctl restart mysql
sudo systemctl restart php7.2-fpm
sudo systemctl restart nginx

sudo ufw status
sudo ufw app list
nginx -v
php -v
mysql -V

printf "${bold_txt}\nJob Done.\n${normal_txt}"
