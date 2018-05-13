#!/bin/bash

# APT Quick Shell
# Version: 1.1

# Commands & Descriptions:
#	update : Update & Upgrade All.
#	clean  : Clean All + Empty Trash & Temp also.
#	both   : Update & Clean.
#	purge  : Clean All + Remove Cache, Unnecessary Files & Packages & Old unused Kernel.
#	fix    : Fixing Installed & Configuring.
#	all    : Run All (Update, Clean Purge & Fix).

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

if_func_run=f
while getopts c:s:u: option; do
	case $option in
		c) _command=$OPTARG;;
		s) s_flag=$OPTARG;;
		u) u_flag=$OPTARG;;
	esac
done

function run_update() {
	sudo apt-get update -y
	sudo apt-get upgrade -y
	sudo apt-get dist-upgrade -y
	sudo apt update -y
	sudo apt upgrade -y
	if_func_run=t
}

function run_clean() {
	sudo apt-get auto-remove -y
	sudo apt-get auto-clean -y
	sudo apt auto-remove -y
	sudo apt auto-clean -y
	if [ $u_flag = sudo ]; then
		sudo rm -rf /home/$USER/.local/share/Trash/*
		sudo rm -rf /tmp/*
	else
		rm -rf /home/$USER/.local/share/Trash/*
		rm -rf /tmp/*
	fi
	if_func_run=t
}

function run_purge() {
	sudo apt-get remove -y
	sudo apt remove -y
	sudo apt-get clean -y
	sudo apt clean -y
	sudo apt-get autoremove --purge
	if_func_run=t
}

function run_fix() {
	sudo apt-get install -f
	sudo dpkg --configure -a
	if_func_run=t
}

if [ -z $_command ]; then
printf "${bold_txt}update: ${normal_txt}To Update & Upgrade All.
${bold_txt}clean: ${normal_txt}Clean All + Empty Trash & Temp also.
${bold_txt}both: ${normal_txt}Update & Clean.
${bold_txt}purge: ${normal_txt}Clean All + Remove Cache, Unnecessary Files & Packages & Old unused Kernel.
${bold_txt}fix: ${normal_txt}Fixing Installed & Configuring.
${bold_txt}all: ${normal_txt}Run All (Update, Clean Purge & Fix).
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
	purge) run_purge
		run_clean
	;;
	fix) run_update
		run_fix
		run_update
	;;
	all) run_purge
		run_clean
		run_update
		run_fix
		run_update
		run_clean
	;;
esac

if [ $if_func_run = t ]; then
	printf "${bold_txt}Complete.\n${normal_txt}"

	case $s_flag in
		shutdown) shutdown -P now;;
		restart) reboot;;
		logout) gnome-session-quit --no-prompt;;
	esac
fi
