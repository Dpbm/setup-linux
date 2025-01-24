#!/bin/bash

LOCAL_BIN="$HOME/.local/bin"

RESET_COLOR="\033[0m"
GREEN="\033[0;92m"
BLUE="\033[0;94m"
PURPLE="\033[0;95m"

log_installing(){
	# https://stackoverflow.com/questions/5412761/using-colors-with-printf
	printf "%b\n" "${GREEN}Installing ${1}...${RESET_COLOR}\n"
}

log_downloading(){
	# https://stackoverflow.com/questions/5412761/using-colors-with-printf
	printf "%b\n" "${BLUE}Downloading ${1}...${RESET_COLOR}\n"
}

setup_vars(){
	VARS_PATH="$HOME/.vars.sh"
	if [ -f $VARS_PATH ]
	then
		return
	fi

	printf "%b\n" "${PURPLE}Setup Variables...${RESET_COLOR}\n"
	cp ./.vars.sh $HOME/
	echo "source $VARS_PATH" >> $HOME/.bashrc
	echo "source $VARS_PATH" >> $HOME/.zshrc
}


install_update_script(){
	UPDATE_SCRIPT_URL="https://github.com/Dpbm/update-all"
	UPDATE_SCRIPT_PATH="$HOME/update-all"
	
	if [ ! $(which git) &>/dev/null ]
	then
		install_git
	fi

	if [ -d $UPDATE_SCRIPT_PATH ]
	then
		return
	fi

	log_downloading "Update Script"
	git clone $UPDATE_SCRIPT_URL $UPDATE_SCRIPT_PATH
	chmod +x $UPDATE_SCRIPT_PATH/update-all
	ln -s $UPDATE_SCRIPT_PATH/update-all $LOCAL_BIN
}

create_directory_if_doesnt_exists(){
	if [ ! -d $1 ]
	then
		printf "%b\n" "${PURPLE}Creating ${1}...${RESET_COLOR}\n"
		mkdir -p $1
	fi
}

setup_directories(){
	create_directory_if_doesnt_exists $LOCAL_BIN
}

update_package_managers(){
	sudo apt update && sudo apt upgrade -y
	sudo apt autoremove -y
}

install_git(){
	log_installing "git"
	sudo apt install git -y
}

install_inkscape(){
	log_installing "inkscape"
	sudo apt install inkscape -y
}

install_imagemagick(){
	log_installing "ImageMagick"
	sudo apt install imagemagick -y
}

install_vim(){
	log_installing "Vim"
	sudo apt install vim -y
}

install_htop(){
	log_installing "Htop"
	sudo apt install htop -y
}

install_tmux(){
	log_installing "TMUX"
	sudo apt install tmux -y
}

install_curl(){
	log_installing "CURL"
	sudo apt install curl -y
}

install_chrome(){
	CHROME_DOWNLOAD_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

	if [ $(which google-chrome) &>/dev/null ]
	then
		return
	fi

	check_curl
	
	log_downloading "Chrome"
	curl -L "$CHROME_DOWNLOAD_URL" -o /tmp/chrome.deb
	log_installing "Chrome"
	sudo apt install /tmp/chrome.deb -y
}

install_zsh(){
	log_installing "ZSH"
	sudo apt install zsh -y
}

install_jetbrains_toolbox(){
	if [ $(which jetbrains-toolbox) &>/dev/null ]
	then
		return
	fi

	check_curl

	TOOLBOX_URL="https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.5.2.35332.tar.gz"

	log_downloading "Jetbrains Toolbox"
	curl -L "$TOOLBOX_URL" -o /tmp/jetbrains-toolbox.tar.gz
       	tar -xvf /tmp/jetbrains-toolbox.tar.gz -C /tmp
	mv /tmp/jetbrains-toolbox-2.5.2.35332 $HOME/jetbrains-toolbox

	log_installing "Jetbrains Toolbox"
	ln -s $HOME/jetbrains-toolbox/jetbrains-toolbox $LOCAL_BIN
}

install_docker(){

	if [ $(which docker) &>/dev/null ]
	then
		return
	fi

	check_curl

	sudo apt-get install ca-certificates -y
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	log_installing "Docker"
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

	sudo groupadd docker
	sudo usermod -aG docker $USER
	newgrp docker
}

check_curl(){
	if [ ! $(which curl) &>/dev/null ]
	then
		install_curl
	fi
}

install_vscode(){
	if [ $(which code) &>/dev/null ]
	then
		return
	fi

	check_curl

	VSCODE_DOWNLOAD_URL="https://vscode.download.prss.microsoft.com/dbazure/download/stable/cd4ee3b1c348a13bafd8f9ad8060705f6d4b9cba/code_1.96.4-1736991114_amd64.deb"

	log_downloading "VSCode"	
	curl -L "$VSCODE_DOWNLOAD_URL" -o /tmp/vscode.deb
	log_installing "VSCode"	
	sudo apt install /tmp/vscode.deb -y
}

install_neovim(){
	if [ $(which nvim) &>/dev/null ]
	then
		return
	fi

	check_curl

	NEOVIM_DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v0.10.3/nvim-linux64.tar.gz"

	log_downloading "Neovim"	
	curl -L "$NEOVIM_DOWNLOAD_URL" -o /tmp/nvim.tar.gz
	tar -xvf /tmp/nvim.tar.gz -C /tmp

	mv /tmp/nvim-linux64 $HOME/nvim

	log_installing "Neovim"	
	ln -s $HOME/nvim/bin/nvim $LOCAL_BIN
}

install_virtualbox(){
	log_installing "Virtual Box"
	sudo apt install virtualbox virtualbox-ext-pack
}

install_github_cli(){
	log_installing "Github CLI"
	(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
}

install_exiftool(){
	check_curl

	log_downloading "Exiftool"

	EXIFTOOL_DOWNLOAD_URL="https://exiftool.org/Image-ExifTool-13.15.tar.gz"
	curl -L "$EXIFTOOL_DOWNLOAD_URL" -o /tmp/exiftool.tar.gz
	tar -xvf /tmp/exiftool.tar.gz -C /tmp
	mv /tmp/Image-ExifTool-13.15 $HOME/exiftool

	log_installing "Exiftool"
	ln -s $HOME/exiftool/exiftool $LOCAL_BIN
}

install_ohmyzsh(){
	check_curl

	log_installing "Oh My ZSH"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_mise(){
	check_curl

	log_installing "Mise"

	curl https://mise.run | sh
}

install_real_vnc_viewer(){
	check_curl
	
	log_downloading "Real VNC Viewer"
	VNC_DOWNLOAD_URL="https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.13.1-Linux-x64.deb"
	curl -L "$VNC_DOWNLOAD_URL" -o /tmp/vnc.deb
	log_installing "Real VNC Viewer"
	sudo apt install /tmp/vnc.deb -y
}
