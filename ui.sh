#!/bin/bash

set -e

TITLE="Setup New Distro"
SCREEN_SIZE=$(stty size)
WIDTH=$( echo $SCREEN_SIZE | awk '{printf $1;}' )
HEIGHT=$( echo $SCREEN_SIZE | awk '{printf $2;}' )

source ./softwares.sh
source ./distros.sh
source ./utils.sh

DISTRO=$DEFAULT_DISTRO
SELECTED_SOFTWARES=${DEFAULT_SOFTWARES[@]}

select_distro(){
	lines=()
	for distro in "${!DISTROS[@]}"; do
		lines+=("$distro" "${DISTROS_DESCRIPTIONS[$distro]}" "${DISTROS[$distro]}")
	done

	DISTRO=$(
		whiptail --title "$TITLE" \
			--nocancel \
			--radiolist "Select Your Distro" \
			$WIDTH $HEIGHT 4 \
			"${lines[@]}" \
			3>&2 2>&1 1>&3
	)
}

select_software(){
	# check if software is already selected
	lines=()
	for software in "${!SOFTWARES[@]}"; do
		lines+=("$software" "${DESCRIPTIONS[$software]}" "${SOFTWARES[$software]}")
	done

	SELECTED_SOFTWARES=$(
		whiptail --title "$TITLE" \
			--nocancel \
			--checklist "Select the Softwares you want to install" \
			$WIDTH $HEIGHT 10 \
			"${lines[@]}" \
			3>&2 2>&1 1>&3
	)
}

install_softwares(){
	setup_directories && update_package_managers

	#setup vars and aliasses
	for software in ${SELECTED_SOFTWARES[@]}; do
		case "$software" in
			'"updateAll"')
				install_update_script
				;;
			'"git"')
				install_git
				;;
			'"Inkscape"')
				install_inkscape
				;;
			'"Imagemagick"')
				install_imagemagick
				;;
			'"VIM"')
				install_vim
				;;
			'"htop"')
				install_htop
				;;
			'"tmux"')
				install_tmux
				;;
			'"Chrome"')
				install_chrome
				;;
			'"curl"')
				install_curl
				;;
			'"zsh"')
				install_zsh
				;;
			'"JetbrainsToolbox"')
				install_jetbrains_toolbox
				;;
			'"Docker"')
				install_docker
				;;
			'"VSCode"')
				install_vscode
				;;
			'"NeoVim"')
				install_neovim
				;;
			*)
				echo "FUCK"
				;;
		esac
	done
	exit
}


while [ 1 ]
do

	OPTION=$(
		whiptail --title "$TITLE" \
			--menu "" \
			$WIDTH $HEIGHT 10 \
			"Install" "Install everything" \
			"Distro" "Change Distro" \
			"Software" "Select the Softwares you want to install" \
			3>&2 2>&1 1>&3
	)

	EXIT_CODE=$?

	if [ "$EXIT_CODE" == 1 ]
	then
		exit
	elif [ "$EXIT_CODE" == 0 ] && [ "$OPTION" == "Install" ]
	then	
		install_softwares
	fi

	
	case $OPTION in
		"Distro")
			select_distro
			;;

		"Software")
			select_software
			;;
		*)
			;;
	esac
done


