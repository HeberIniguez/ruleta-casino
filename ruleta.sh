#!/bin/bash

# Colores
end="\033[0m\e[0m"
colorRojo="\e[0;31m\033[1m"
colorVerde="\e[0;32m\033[1m"
colorAmarillo="\e[0;33m\033[1m"
colorAzul="\e[0;34m\033[1m"
colorMorado="\e[0;35m\033[1m"
colorTurquesa="\e[0;36m\033[1m"
colorGris="\e[0;37m\033[1m"

# Funcion para salir del programa
function ctrl_c(){
    echo -e "\n\n${colorRojo}[!] Saliendo... ${end}\n"
    tput cnorm
    exit 1
}

# Ctrl+C
trap ctrl_c INT

function helpPanel(){
    echo -e "\n${colorAmarillo}[+]${end}${colorGris} Uso:${end}${colorMorado} $0${end}\n"
    echo -e "\t${colorAzul}-c)${end}${colorGris} Especificar la cantidad de credito con la que jugara.${end}"
    echo -e "\t${colorAzul}-t)${end}${colorGris} Tecnica a utilizar${end}${colorMorado} (${end}${colorAmarillo}martingala${end}${colorAzul}/${end}${colorAmarillo}inverseLabrouchere${end}${colorMorado})${end}"
    exit 1
}

function martingala(){
    echo -e "\n${colorAmarillo}[+]${end} Credito actual: ${colorAmarillo}$credito$ ${end}"
    echo -ne "${colorAmarillo}[+]${end} Ingrese el credito que desea apostar: " && read initial_bet
    echo -ne "${colorAmarillo}[+]${end} Selecione la opcion a la que apostara continuamente (par/impar): " && read par_impar

    echo -e "\n${colorAmarillo}[+]${end} Vamos a jugar con una cantidad inicial de ${colorAmarillo}$initial_bet$ ${end}a ${colorAmarillo}$par_impar${end}"

    backup_bet=$initial_bet

    tput civis # Ocultar cursor
    while true; do
        if [ "$credito" -le "$initial_bet" ]; then
            echo -e "\n${colorAmarillo}[!]${end} ${colorRojo}Tu credito es insuficiente.${end}"
            echo -e "${colorAmarillo}[!]${end} La apuesta es de ${colorAmarillo}$initial_bet$ ${end}y solo te quedan ${colorAmarillo}${credito}$ ${end}"
            tput cnorm; exit 0
        fi

        credito=$(($credito-$initial_bet))
        echo -e "Acabas de apostar ${colorAmarillo}$initial_bet${end} y tu nuevo credito es de ${colorAmarillo}$credito${end}"

        numeroAleatorio="$(($RANDOM % 37))"
        echo -e "\n${colorAmarillo}[+]${end} Ha salido el numero ${colorAzul}$numeroAleatorio${end}"

        if [ "$par_impar" == "par" ]; then
            if [ "$(($numeroAleatorio % 2))" -eq 0 ]; then
                if [ "$numeroAleatorio" -eq 0 ]; then
                    echo -e "${colorRojo}[!]${end} Ha salido el numero 0, por lo tanto has ${colorRojo}PERDIDO!${end}"
                else
                    echo -e "${colorAmarillo}[+]${end} El numero que ha salido es ${colorAmarillo}PAR${end}, has ${colorVerde}GANADO!${end}"
                    reward=$(($initial_bet*2))
                    echo -e "${colorVerde}[+] Ganaste un total de ${end}${colorAmarillo}$reward$ ${end}"
                    credito=$(($credito+$reward))
                    echo -e "${colorAmarillo}[+]${end} Tu nuevo credito es de ${colorAmarillo}$credito$ ${end}"
                    initial_bet=$backup_bet
                fi
            else
                echo -e "${colorRojo}[!]${end} El numero que ha salido es ${colorAmarillo}IMPAR${end}, has ${colorRojo}PERDIDO! ${end}"
                initial_bet=$((initial_bet*2))
                echo -e "${colorAmarillo}[+]${end} Tu nuevo credito es de ${colorAmarillo}$credito$ ${end}"
            fi 
        fi    
        sleep 2
    done
    tput cnorm # Recuperar cursor
}

while getopts "c:t:h" args; do 
    case $args in
        c) credito=$OPTARG;;
        t) tecnica=$OPTARG;;
        h) helpPanel
    esac 
done

# Tiene que especificarse el credito y la tecnica a usar
if [ $credito ] && [ $tecnica ]; then
    if [ "$tecnica" == "martingala" ]; then
        martingala
    else
        echo -e "\n${colorRojo}[!] La tecnica introducida no existe${end}"
        helpPanel
    fi 
else
    helpPanel
fi
