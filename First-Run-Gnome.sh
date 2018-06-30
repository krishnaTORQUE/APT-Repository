#!/bin/bash

# APT First Run GNOME
# Version: 1.3

# NOTE:
# 	Run only once when you install fresh GNOME based OS
#	Require Internet

# Changes:
#		Adding New File Option in Context Menu
#		Dock Minimize
#		Dock Reposition (Bottom)

# PPA Adding:
# 			Graphics Driver
#			Gnome
#			LibreOffice

# Install (Auto):
#		quicks.sh
#		Restricted Extras
# 		Xserver Xorg
# 		Dconf Editor
# 		Gnome Tweak Tool
#		Gnome Shell
#		Gnome Extensions

# Install (By User):
#		VLC Player
#		LibreOffice
#		Chrome Browser
#		Play On Linux
#		Antivirus (ClamAV & ClamTK)
#		Git

printf "
    _    ____ _____   _____ ___ ____  ____ _____   ____  _   _ _   _ 
   / \  |  _ |_   _| |  ___|_ _|  _ \/ ___|_   _| |  _ \| | | | \ | |
  / _ \ | |_) || |   | |_   | || |_) \___ \ | |   | |_) | | | |  \| |
 / ___ \|  __/ | |   |  _|  | ||  _ < ___) || |   |  _ <| |_| | |\  |
/_/   \_|_|    |_|   |_|   |___|_| \_|____/ |_|   |_| \_\\___/|_| \_|
  ____ _   _  ___  __  __ _____  ____  _____ ____  _  _______ ___  ____  
 / ___| \ | |/ _ \|  \/  | ____| |  _ \| ____/ ___|| |/ |_   _/ _ \|  _ \ 
| |  _|  \| | | | | |\/| |  _|   | | | |  _| \___ \| ' /  | || | | | |_) |
| |_| | |\  | |_| | |  | | |___  | |_| | |___ ___) | . \  | || |_| |  __/ 
 \____|_| \_|\___/|_|  |_|_____| |____/|_____|____/|_|\_\ |_| \___/|_|    

                             Version: 1.3

"

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

# Asking user to reposition Dock at Bottom
printf "${bold_txt}Would you like to reposition dock at bottom?${normal_txt} [Y/n]: "
read dock_bottom

# Asking user to install VLC Player
printf "${bold_txt}Do you want to install VLC Player?${normal_txt} [Y/n]: "
read install_vlc

# Asking user to install Chrome
printf "${bold_txt}Do you want to install Chrome Browser?${normal_txt} [Y/n]: "
read install_chrome

# Asking user to install LibreOffice
printf "${bold_txt}Do you want to install LibreOffice?${normal_txt} [Y/n]: "
read install_libreoffice

# Asking user to install Play On Linux
printf "${bold_txt}Do you want to install Play On Linux?${normal_txt} [Y/n]: "
read install_playonlinux

# Asking user to install Antivirus (ClamAV)
printf "${bold_txt}Do you want to install Antivirus (ClamAV)?${normal_txt} [Y/n]: "
read install_clamav

# Asking user to install ClamTK if ClamAV true
if [[ $install_clamav = Y ]] || [[ $install_clamav = y ]]; then
	printf "${bold_txt}Do you want to install ClamTK?${normal_txt} [Y/n]: "
	read install_clamtk
fi

# Asking user to install Git
printf "${bold_txt}Do you want to install Git?${normal_txt} [Y/n]: "
read install_git


### All Done ###
printf "${bold_txt}All Set. Please wait, it will take some time. \nProcessing ...\n\n${normal_txt}"

# Enable Firewall
sudo ufw enable

# Creating File Shortcut in Menu
touch ~/Templates/New

# Adding Graphics Drivers PPA
sudo add-apt-repository ppa:graphics-drivers/ppa

# Adding Gnome Extension PPA
sudo add-apt-repository ppa:gnome3-team/gnome3

# Adding LibreOffice PPA
sudo add-apt-repository ppa:libreoffice/ppa

# Adding PPA Play On Linux If true
if [[ $install_playonlinux = Y ]] || [[ $install_playonlinux = y ]]; then
	wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
	sudo wget http://deb.playonlinux.com/playonlinux_trusty.list -O /etc/apt/sources.list.d/playonlinux.list
fi

# Update & Upgrade All
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt update -y
sudo apt upgrade -y

# Adding quicks to home directory for better update & cleaning system
wget https://raw.githubusercontent.com/krishnaTORQUE/APT-Repository/master/quicks.sh -P /home/$USER/

# Ubuntu Codecs
sudo apt-get install ubuntu-restricted-extras -y
sudo dpkg-reconfigure libdvd-pkd -y

# Install Xorg for Library & Drivers
sudo apt-get install xserver-xorg -y

# Install Dconf-Editor
sudo apt install dconf-editor -y

# Install Gnome Tweak Tool & Shell & Extensions
sudo apt install gnome-tweak-tool -y
sudo apt-get install chrome-gnome-shell -y
sudo apt install gnome-shell-extensions -y

# Minimize when clicking icon in dock
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

# Reposition dock at bottom if true
if [[ $dock_bottom = Y ]] || [[ $dock_bottom = y ]]; then
	gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
fi

# Install VLC Player If true
if [[ $install_vlc = Y ]] || [[ $install_vlc = y ]]; then
	sudo apt install vlc -y
fi

# Install Chrome If true
if [[ $install_chrome = Y ]] || [[ $install_chrome = y ]]; then
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp/
	sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
fi

# Install LibreOffice If true
if [[ $install_libreoffice = Y ]] || [[ $install_libreoffice = y ]]; then
	sudo apt-get install libreoffice -y
fi

# Install Anti Virus ClamAV
if [[ $install_clamav = Y ]] || [[ $install_clamav = y ]]; then
	sudo apt-get install clamav -y
fi

# Install ClamTK If true
if [[ $install_clamtk = Y ]] || [[ $install_clamtk = y ]]; then
	sudo apt-get install clamtk -y
fi

# Install Play On Linux If true
if [[ $install_playonlinux = Y ]] || [[ $install_playonlinux = y ]]; then
	sudo apt-get install playonlinux -y
fi

# Install Git If true
if [[ $install_git = Y ]] || [[ $install_git = y ]]; then
	sudo apt-get install git-core -y
fi

printf "${bold_txt}Job Completed.\n\n${normal_txt}"
