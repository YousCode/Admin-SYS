#!/usr/bin/env bash

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
BLUE='\033[0;104m'
RED='\033[0;101m'
NC='\033[0m' # No Color
function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
    if [[ $key = $ESC[A ]]; then echo up;    fi
    if [[ $key = $ESC[B ]]; then echo down;  fi
    if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}
echo "Bienvenue sur le Minitel v3"
sleep 0.3
echo "Veuillez mettre le nom d'utilisateur :"
read nom
clear
echo "Bienvenue $nom sur le Minitel v3"
while true; do
echo "Select une option avec les fleches de haut/bas puis appuyer sur [ENTR??E]:"
echo

options=("Information systeme" "R??seaux" "Processus" "${RED}Exit${NC}")

select_option "${options[@]}"
choice=$?

if [ $choice = 0 ]; then
	echo "Choississez qu'est ce que vous voulez afficher:"

	option0=("Version du syst??me" "Uptime" "Version du Kernel" "Information Hardware >" "Limite de fichiers ouverts" "Limite de processus ouverts" "Nombre de fichier ouvert par tous les processus")
	select_option "${option0[@]}"
	choice0=$?

	if [ $choice0 = 0 ]; then
		echo -e "Version du syst??me :\n  ${BLUE}$(lsb_release -d)${NC}"
	fi
	if [ $choice0 = 1 ]; then
		echo -e "Uptime :\n ${BLUE}$(uptime)${NC}"
	fi
	if [ $choice0 = 2 ]; then
		echo -e "Version du kernel :\n  ${BLUE}$(uname -mr)${NC}"
	fi
	if [ $choice0 = 3 ]; then
		echo "Information Hardware :"
		echo "Choisissez :"

		option01=("CPU" "M??moire" "Disque Dur")
        	select_option "${option01[@]}"
        	choice01=$?

		if [ $choice01 = 0 ]; then
			echo -e "CPU :\n ${BLUE}$(lscpu)${NC}"
		fi
		if [ $choice01 = 1 ]; then
			echo -e "RAM :\n ${BLUE}$(free -m)${NC}"
		fi
		if [ $choice01 = 2 ]; then
			echo -e "Info sur Disque Dur :\n ${BLUE}$(df -Th /dev/sda1)${NC}"
		fi
	fi
	if [ $choice0 = 4 ]; then
		echo -e "Limite de fichiers ouverts :\n ${BLUE}$(ulimit -n)${NC}"
	fi
	if [ $choice0 = 5 ]; then
		echo -e "Limite de processus ouverts :\n ${BLUE}$(ulimit -u)${NC}"
	fi
	if [ $choice0 = 6 ]; then
		echo -e "Nombre de fichiers ouverts par tous les processus :\n ${BLUE}$(lsof | wc -l)${NC}"
	fi
fi
if [ $choice = 1 ]; then
	echo "Choisissez ce que vous voulez afficher :"

	option1=("Adresse ip" "Interfaces existantes" "Nombre de paquets transmis/re??us" "Routes" "Voir si le forward du paquet est activ??")
	select_option "${option1[@]}"
	choice1=$?

	if [ $choice1 = 0 ]; then
		echo -e "Adresse IP :\n${BLUE}$(./a.out)${NC}"
	fi
	if [ $choice1 = 1 ]; then
		echo -e "Interfaces existantes :\n${BLUE}$(ip a | grep UP | cut -d " " -f 2 | cut -d ":" -f 1)${NC}"
	fi
	if [ $choice1 = 2 ]; then
		echo -e "Nombre de paquets transmis/re??us :\n${BLUE}$(ping -c 5 google.com)${NC}"
	fi
	if [ $choice1 = 3 ]; then
                echo -e "Routes :\n${BLUE}$(sudo route -n)${NC}"
        fi
	if [ $choice1 = 4 ]; then
		echo -e "Forward activ?? ? 0=non 1=oui :\n${BLUE}$(cat /proc/sys/net/ipv4/ip_forward)${NC}"
	fi
fi
if [ $choice = 2 ]; then
	echo "Choisissez ce que vous voulez aficher"

	option2=("Toutes les informations des processus" "Kill un processus >")
	select_option "${option2[@]}"
	choice2=$?
	if [ $choice2 = 0 ]; then
		echo -e "Toutes les information sur les processus :\n${BLUE}$(ps -axu)${NC}"
	fi
	if [ $choice2 = 1 ]; then
                echo "Possibilit?? de Kill un processus :"
                echo "Choisissez :"

                option21=("Kill mode simple" "Kill mode forc??")
                select_option "${option21[@]}"
                choice21=$?

                if [ $choice21 = 0 ]; then
                        echo "Renseigner le PID du processus que vous voules kill : "
			read PID1
			sudo kill $PID1
			echo -e "${BLUE}Le processus au PID ($PID1) a bien ??t?? kill${NC}"
                fi
                if [ $choice21 = 1 ]; then
                        echo "Renseigner le PID du processus que vous voules kill : "
                        read PID2
                        sudo kill -9 $PID2
			echo -e "${BLUE}Le processus au PID ($PID2) a bien ??t?? kill${NC}"
                fi
        fi
fi
if [ $choice = 3 ]; then
	clear
	exit
fi
read -p "Appuyez sur [ENTR??E] pour retourner au menu"
clear
done
