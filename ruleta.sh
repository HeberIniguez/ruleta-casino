#!/bin/bash

#Colores
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
    echo -e "\n[+] Vamos a jugar con la tecnica martingala\n"
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
