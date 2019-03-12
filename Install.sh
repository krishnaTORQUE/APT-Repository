#!/bin/bash

printf "
	 _   _ __  __ ____  
	| \ | |  \/  |  _ \ 
	|  \| | |\/| | |_) |
	| |\  | |  | |  __/ 
	|_| \_|_|  |_|_|    

            Version: 1.12

"

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

# Asking user to install phpMyAdmin #
printf "${bold_txt}Would you like to use phpMyAdmin?${normal_txt} [Y/n]: "
read install_phpmyadmin

# Change Ownership #
function chdir_owner() {
	sudo chown -R $USER:www-data /var/www
	sudo chown -R $USER:www-data /var/www/*
	sudo chmod -R u=rwx,g=rwx,o=- /var/www
	sudo chmod -R u=rwx,g=rwx,o=- /var/www/*
}

# Add PPA & Install #
printf "${bold_txt}\nProcessing ...\n${normal_txt}"
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:nginx/stable -y
sudo add-apt-repository ppa:ondrej/php -y
wget -P /tmp https://repo.mysql.com//mysql-apt-config_0.8.10-1_all.deb
sudo dpkg -i /tmp/mysql-apt-config_0.8.10-1_all.deb

# Upgrade #
printf "${bold_txt}\nUpdating ...\n${normal_txt}"
sudo apt update -y
sudo apt list --upgradable
sudo apt upgrade -y
sudo apt dist-upgrade -y

# Install Nginx #
printf "${bold_txt}\nInstalling Nginx ...\n${normal_txt}"
sudo apt install nginx -y

# Install PHP & Library #
printf "${bold_txt}Nginx Installed \n\nInstalling PHP ...\n${normal_txt}"
sudo apt install php7.3-fpm php7.3-common php7.3-mysql php7.3-curl php7.3-json php7.3-gd php7.3-zip php7.3-mbstring php7.3-xml php7.3-opcache php7.3-xmlrpc php7.3-ssh2 libssh2-1 -y

# Install MySQL #
printf "${bold_txt}PHP Installed \n\nInstalling MySQL ...\n${normal_txt}"
sudo apt install mysql-server -y

# Install Done #
printf "${bold_txt}MySQL Installed\n${normal_txt}"

# ReConfigure NMP #
printf "${bold_txt}\nConfiguring NMP ...\n${normal_txt}"
chdir_owner

# Configure Nginx #
sudo cp $SCRIPTPATH/files/nginx-default /etc/nginx/sites-available/default
sudo chown root:root /etc/nginx/sites-available/default
sudo cp $SCRIPTPATH/files/nginx.conf /etc/nginx/nginx.conf
sudo chown root:root /etc/nginx/nginx.conf

# Configure PHP
sudo chown $USER:$USER /etc/php/7.3/fpm/php.ini
php_cwd=`/usr/bin/php << 'EOF'
<?php
$php_ini_f = '/etc/php/7.3/fpm/php.ini';
$php_ini = file_get_contents($php_ini_f);
$search = ['@post_max_size.*@i', '@upload_max_filesize.*@i', '@max_file_uploads.*@i'];
$replace = ['post_max_size = 100M', 'upload_max_filesize = 100M', 'max_file_uploads = 50'];
$content_edit = preg_replace($search, $replace, $php_ini);
file_put_contents($php_ini_f, $content_edit);
?>
EOF`
echo "$php_cwd"
sudo chown root:root /etc/php/7.3/fpm/php.ini

# Configure MySQL #
sudo mysql_secure_installation

# Installing phpMyAdmin if true #
if [[ $install_phpmyadmin = Y ]] || [[ $install_phpmyadmin = y ]]; then

    # Download & Extract > /tmp #
	sudo rm -rf /tmp/phpMyAdmin*
	wget -P /tmp https://files.phpmyadmin.net/phpMyAdmin/4.8.5/phpMyAdmin-4.8.5-english.zip
	unzip /tmp/phpMyAdmin-4.8.5-english.zip -d /tmp

    # Delete Old #
	phpmyadmin_dir='/var/www/html/phpmyadmin'
	if [ -d $phpmyadmin_dir ]; then
		rm -rf $phpmyadmin_dir
	fi
	
	# Copy New #
	mkdir $phpmyadmin_dir
	cp -rf /tmp/phpMyAdmin-4.8.5-english/. $phpmyadmin_dir

    # Clear #
	rm -rf /tmp/phpMyAdmin*
fi

# Remove Default Index File #
index_debian_file='/var/www/html/index.nginx-debian.html'
if [ -f $index_debian_file ]; then
	rm '/var/www/html/index.nginx-debian.html'
fi

# Remove Old Index #
nmp_index='/var/www/html/index.php'
if [ -f $nmp_index ]; then
	rm $nmp_index
fi

# Remove Old Info #
nmp_info='/var/www/html/info.php'
if [ -f $nmp_info ]; then
	rm $nmp_info
fi

# Add New Index & Info #
cp $SCRIPTPATH/files/info.php /var/www/html/info.php
cp $SCRIPTPATH/files/index.php /var/www/html/index.php

# Remove MySQL .deb File #
rm /tmp/mysql-apt-config_0.8.10-1_all.deb

# Change Ownership #
chdir_owner

# Clearup #
sudo apt autoremove --purge -y
sudo apt autoclean -y
sudo apt remove -y
sudo apt clean -y

# Setup Firewall
sudo ufw enable
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 80
sudo ufw allow 443

printf "${bold_txt}\nConfiguring Complete. \n${normal_txt}"

# Restart NMP #
sudo systemctl restart mysql
sudo systemctl restart php7.3-fpm
sudo systemctl restart nginx

# Show Details #
sudo ufw status
sudo ufw app list
nginx -v
php -v
mysql -V

printf "${bold_txt}NMP Install Complete.\n\n${normal_txt}"
