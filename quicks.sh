#!/bin/bash

# APT Quick Shell
# Version: 1.9

## Commands ##		## Descriptions ##
#	update 		: Update & Upgrade All.
#	clean  		: Clean Apps & Packages + Empty Trash, Temp, Remove Cache, Unnecessary Files & Packages & Old unused Kernel.
#	both   		: Update & Clean.
#	fix    		: Fixing Installed Apps & Configuration.
#	all    		: Run All (Update, Clean & Fix).
# 	superclean	: Remove Root / System Cache, Unnecessary Files.

# Note: Require Internet Connection

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

if_func_run=f
while getopts c:s: option; do
	case $option in
		c) _command=$OPTARG;;
		s) s_flag=$OPTARG;;
	esac
done

function run_update() {
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt dist-upgrade -y
	if_func_run=t
}

function run_fix() {
	sudo dpkg --configure -a
	sudo apt install -f
	if_func_run=t
}

function run_clean() {
	sudo rm -rf /home/$USER/.local/share/Trash/*
	sudo find /tmp/ -type f -mtime +1 -exec sudo rm {} \;
	sudo find /tmp/ -type f -atime +1 -exec sudo rm {} \;
	sudo apt remove -y
	sudo apt clean -y
	sudo apt autoremove --purge -y
	sudo apt autoclean -y
	if_func_run=t
}

function run_super_clean() {
	sudo rm -rf /tmp/*
	rm /home/$USER/.bash_history
	rm  /home/$USER/.local/share/user-places.xbel.bak
	rm -rf /home/$USER/.cache/evolution/*
	rm -rf /home/$USER/.cache/thumbnails/*
	find /home/$USER/.cache/ -type f -mtime +1 -exec rm {} \;
	find /home/$USER/.cache/ -type f -atime +1 -exec rm {} \;
	sudo find /var/backups/ -type f -mtime +1 -exec sudo rm {} \;
	sudo find /var/backups/ -type f -atime +1 -exec sudo rm {} \;
	sudo find /var/log/ -type f -mtime +1 -exec sudo rm {} \;
	sudo find /var/log/ -type f -atime +1 -exec sudo rm {} \;
	sudo find /var/cache/apt/archives/ -type f -mtime +1 -exec sudo rm {} \;
	sudo find /var/cache/apt/archives/ -type f -atime +1 -exec sudo rm {} \;
	if_func_run=t
}

if [ -z $_command ]; then
printf "${bold_txt}update: ${normal_txt}Update & Upgrade All.
${bold_txt}clean: ${normal_txt}Clean Apps & Packages + Empty Trash, Temp, Remove Cache, Unnecessary Files & Packages & Old unused Kernel.
${bold_txt}both: ${normal_txt}Update & Clean.
${bold_txt}fix: ${normal_txt}Fixing Installed Apps & Configuration.
${bold_txt}all: ${normal_txt}Run All (Update, Clean & Fix).
${bold_txt}superclean: ${normal_txt}Remove Root / System Cache, Unnecessary Files.
Default is: ${bold_txt}both${normal_txt}. Press ${bold_txt}command / control + c ${normal_txt}to cancel.
${bold_txt}Enter Command:\n${normal_txt}"
read _command
fi

case $_command in
	update) run_update;;
	clean) run_clean;;
	*|both) run_clean
		run_update
		run_clean
	;;
	fix) run_fix
		run_clean
		run_update
	;;
	all) run_clean
		run_fix
		run_update
		run_clean
	;;
	superclean) run_clean
		run_super_clean	
		run_clean
	;;
esac

if [ $if_func_run = t ]; then
	printf "${bold_txt}Complete.\n\n${normal_txt}"

	case $s_flag in
		shutdown) shutdown -P now;;
		restart) reboot;;
		logout) sudo pkill -KILL -u $USER;;
	esac
fi
