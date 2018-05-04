#!/bin/bash

# APT Quick Shell
# Version: 1.0
# Update: 04/05/2018 09:10PM (UTC+5:30)

# Commands & Descriptions: 
#	update : Update & Upgrade All.
#	clean  : Clean All & Empty Trash also.
#	both   : Update & Clean.
#	fix    : Fixing Installed & Configuring.
#	all    : Run All (Update, Clean & Fix).

function run_update() {
	sudo apt-get update -y
	sudo apt-get upgrade -y
	sudo apt-get dist-upgrade -y
	sudo apt update -y
	sudo apt upgrade -y
}

function run_clean() {
	sudo apt-get auto-remove -y
	sudo apt-get auto-clean -y
	sudo apt auto-remove -y
	sudo apt auto-clean -y
	rm -rf ~/.local/share/Trash/*
}

function run_fix() {
	sudo apt-get install -f
	sudo dpkg --configure -a
	sudo apt-get install -f
}

bold_txt=$(tput bold)
normal_txt=$(tput sgr0)

printf "${bold_txt}update: ${normal_txt} To Update & Upgrade All.
${bold_txt}clean: ${normal_txt} To Clean All + Trash.
${bold_txt}both: ${normal_txt} Update & Clean.
${bold_txt}fix: ${normal_txt} Fixing Installed & Configuring.
${bold_txt}all: ${normal_txt} Run All (Update, Clean & Fix).
Default is: ${bold_txt}both${normal_txt}. Press ${bold_txt}command / control + c${normal_txt} to cancel.
${bold_txt}Enter Command:\n${normal_txt}"

read _command

if [ -z $_command ]; then
		run_clean
		run_update
		run_clean
		printf "${bold_txt}Complete.\n${normal_txt}"
else
	if [ $_command = all ]; then
		run_clean
		run_update
		run_fix
		run_update
		run_clean
		printf "${bold_txt}Complete.\n${normal_txt}"
	elif [ $_command = both ]; then
		run_clean
		run_update
		run_clean
		printf "${bold_txt}Complete.\n${normal_txt}"
	elif [ $_command = fix ]; then
		run_update
		run_fix
		run_update
		printf "${bold_txt}Complete.\n${normal_txt}"
	elif [ $_command = update ]; then
		run_update
		printf "${bold_txt}Complete.\n${normal_txt}"
	elif [ $_command = clean ]; then
		run_clean
		printf "${bold_txt}Complete.\n${normal_txt}"
	else 
		printf "${bold_txt}Sorry, Command not found.\n${normal_txt}"
	fi
fi
