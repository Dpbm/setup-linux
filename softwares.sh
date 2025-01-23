#!/bin/bash

declare -A SOFTWARES=(["Chrome"]=ON 
       	["Inkscape"]=OFF 
       	["Imagemagick"]=OFF 
	["JetbrainsToolbox"]=OFF 
	["Docker"]=OFF 
	["VSCode"]=ON 
	["VIM"]=ON 
	["NeoVim"]=ON 
	["htop"]=ON 
	["tmux"]=ON
	["zsh"]=ON
	["updateAll"]=ON
	["git"]=ON
	["curl"]=ON
)

declare -A DESCRIPTIONS=(["Chrome"]="Google's Internet Browser" 
	["Inkscape"]="A editor for vector graphics" 
	["Imagemagick"]="A cli tool to manipulate images" 
	["JetbrainsToolbox"]="Jetbrains tool for managing installations" 
	["Docker"]="A tool for Creating software containers" 
	["VSCode"]="Microsoft's IDE" 
	["VIM"]="The classic terminal based text editor" 
	["NeoVim"]="A modern version of VIM" 
	["htop"]="A cli tool for system monitor" 
	["tmux"]="A terminal multiplexer"
	["zsh"]="An alternative to bash"
	["updateAll"]="A simple script to update all your installed softwares"
	["git"]="A version control cli tool"
	["curl"]="command line tool for data transfering over internet"
)

DEFAULT_SOFTWARES=()
for software in "${!SOFTWARES[@]}"
do
	if [ "${SOFTWARES[$software]}" == ON ]
	then
		DEFAULT_SOFTWARES+=("$software")
	fi
done
