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

    echo -e "\n${colorAmarillo}[+]${end} La jugada empezo con ${colorAmarillo}$credito$ ${end}de creditos y una apuesta inicial de ${colorAmarillo}$initial_bet$ ${end}creditos a ${colorAmarillo}$par_impar${end}"

    backup_bet=$initial_bet
    play_counter=1
    bad_counter=0
    bad_plays=""
    max_reward=$credito

    tput civis # Ocultar cursor
    while true; do
        if [ "$credito" -lt "$initial_bet" ]; then
            # echo -e "${colorRojo}[!] Tu credito es insuficiente.${end}"
            # echo -e "${colorAmarillo}[!]${end} La apuesta es de ${colorAmarillo}$initial_bet$ ${end}y solo te quedan ${colorAmarillo}${credito}$ ${end}"
            echo -e "${colorAmarillo}[+]${end} Se realizaron ${colorAmarillo}$(($play_counter-1))${end} jugadas en total."
            echo -e "${colorAmarillo}[+]${end} La ganacia maxima fue de ${colorAmarillo}$(($max_reward-$credito))$ ${end} creditos."
            echo -e "${colorAmarillo}[+]${end} La mala racha de ${colorAmarillo}$bad_counter${end} jugadas consecutivas fue: ${colorRojo}[ $bad_plays]${end}"
            tput cnorm; exit 0
        fi

        credito=$(($credito-$initial_bet))
        # echo -e "Acabas de apostar ${colorAmarillo}$initial_bet${end} y tu nuevo credito es de ${colorAmarillo}$credito${end}"

        numeroAleatorio="$(($RANDOM % 37))"
        # echo -e "\n${colorAmarillo}[+]${end} Ha salido el numero ${colorAzul}$numeroAleatorio${end}"

        # Logica si se eligio par
        if [ "$par_impar" == "par" ]; then 
            if [ "$(($numeroAleatorio % 2))" -eq 0 ]; then
                if [ "$numeroAleatorio" -eq 0 ]; then
                    # echo -e "${colorRojo}[!]${end} Ha salido el numero 0, por lo tanto has ${colorRojo}PERDIDO!${end}"
                    bad_plays+="$numeroAleatorio "
                    let bad_counter+=1
                else
                    # echo -e "${colorAmarillo}[+]${end} El numero que ha salido es ${colorAmarillo}PAR${end}, has ${colorVerde}GANADO!${end}"
                    reward=$(($initial_bet*2))
                    # echo -e "${colorVerde}[+] Ganaste un total de ${end}${colorAmarillo}$reward$ ${end}"
                    credito=$(($credito+$reward))
                    # echo -e "${colorAmarillo}[+]${end} Tu nuevo credito es de ${colorAmarillo}$credito$ ${end}"
                    initial_bet=$backup_bet
                    bad_plays=""
                    bad_counter=0
                fi
            else
                # echo -e "${colorRojo}[!]${end} El numero que ha salido es ${colorAmarillo}IMPAR${end}, has ${colorRojo}PERDIDO! ${end}"
                initial_bet=$((initial_bet*2))
                # echo -e "${colorAmarillo}[+]${end} Tu nuevo credito es de ${colorAmarillo}$credito$ ${end}"
                bad_plays+="$numeroAleatorio "
                let bad_counter+=1
            fi 
        else # Logica si se eligio impar
            if [ "$(($numeroAleatorio % 2))" -eq 1 ]; then
                reward=$(($initial_bet*2))
                credito=$(($credito+$reward))
                initial_bet=$backup_bet
                bad_plays=""
                bad_counter=0
            else
                initial_bet=$((initial_bet*2))
                bad_plays+="$numeroAleatorio "
                let bad_counter+=1
            fi 
        fi    

        if [ ! "$credito" -le "$max_reward" ]; then
            max_reward=$credito
        fi
        let play_counter+=1
    done
    tput cnorm # Recuperar cursor
}

function inverseLabrouchere(){
    echo -e "\n${colorAmarillo}[+]${end} Credito actual: ${colorAmarillo}\$$credito${end}"
    echo -ne "${colorAmarillo}[+]${end} Selecione la opcion a la que apostara continuamente (par/impar): " && read par_impar

    declare -a mi_secuencia=(1 2 3 4)

    echo -e "\n${colorAmarillo}[+]${end} Comenzamos con la secuencia ${colorVerde}[${mi_secuencia[@]}]${end}"

    bet=$((${mi_secuencia[0]} + ${mi_secuencia[-1]})) 
    
    tput civis
    while true; do
    
    if [ "$credito" -lt "$bet" ]; then
        echo -e "${colorRojo}[!] Tu credito es insuficiente.${end}"
        echo -e "${colorAmarillo}[!]${end} La apuesta es de ${colorAmarillo}$bet$ ${end}y solo te quedan ${colorAmarillo}${credito}$ ${end}"
        # echo -e "${colorAmarillo}[+]${end} Se realizaron ${colorAmarillo}$(($play_counter-1))${end} jugadas en total."
        # echo -e "${colorAmarillo}[+]${end} La ganacia maxima fue de ${colorAmarillo}$(($max_reward-$credito))$ ${end} creditos."
        # echo -e "${colorAmarillo}[+]${end} La mala racha de ${colorAmarillo}$bad_counter${end} jugadas consecutivas fue: ${colorRojo}[ $bad_plays]${end}"
        tput cnorm; exit 0
    fi
    
    numeroAleatorio=$(($RANDOM % 37))
    credito=$(($credito - $bet))

    echo -e "\n${colorAmarillo}[+]${end} Invertimos ${colorAmarillo}\$${bet} ${end}creditos"
    echo -e "${colorAmarillo}[+]${end} Tenemos: ${colorAmarillo}\$$credito${end}"
    echo -e "\n${colorAmarillo}[+]${end} Ha salido el numero ${colorAzul}$numeroAleatorio${end}"

    if [ "$par_impar" == "par" ]; then
        if [ "$(($numeroAleatorio % 2))" -eq 0 ] && [ "$numeroAleatorio" -ne 0 ]; then
            echo -e "${colorAmarillo}[+]${end} El numero que ha salido es ${colorVerde}PAR${end}, has ${colorVerde}GANADO!${end}"
            reward=$(($bet * 2))
            let credito+=$reward
            echo -e "${colorAmarillo}[+]${end} Tienes ${colorAmarillo}\$$credito${end}"

            mi_secuencia+=($bet)
            mi_secuencia=(${mi_secuencia[@]})

            echo -e "${colorAmarillo}[+]${end} Nuestra nueva secuencia es: ${colorVerde}[${mi_secuencia[@]}]${end}"

            if [ "${#mi_secuencia[@]}" -gt 1 ]; then
                bet=$((${mi_secuencia[0]} + ${mi_secuencia[-1]}))
            elif [ "${#mi_secuencia[@]}" -eq 1 ]; then
                echo "${#mi_secuencia[@]}"
                bet=${mi_secuencia[0]}
            fi

        elif [ "$(($numeroAleatorio % 2))" -eq 1 ] || [ "$numeroAleatorio" -eq 0 ]; then

            if [ "$numeroAleatorio" -eq 0 ]; then
                echo -e "${colorRojo}[!]${end} Ha salido el numero ${colorRojo}0${end}, has ${colorRojo}PERDIDO! ${end}"
            else
                echo -e "${colorRojo}[!]${end} El numero que ha salido es ${colorRojo}IMPAR${end}, has ${colorRojo}PERDIDO! ${end}"
            fi

            unset mi_secuencia[0]
            unset mi_secuencia[-1] 2>/dev/null

            mi_secuencia=(${mi_secuencia[@]})

            echo -e "${colorAmarillo}[+]${end} La nueva secuencia es: ${colorVerde}[${mi_secuencia[@]}]${end}"
            
            if [ "${#mi_secuencia[@]}" -gt 1 ]; then
                bet=$((${mi_secuencia[0]} + ${mi_secuencia[-1]}))
            elif [ "${#mi_secuencia[@]}" -eq 1 ]; then
                bet=${mi_secuencia[0]}
            fi
      
            if [ "${#mi_secuencia[@]}" -eq 0 ]; then
                echo -e "${colorRojo}[!] Hemos perdido la secuencia${end}"
                mi_secuencia=(1 2 3 4)
                echo -e "${colorAmarillo}[+]${end} Secuencia restablecida a ${colorVerde}[${mi_secuencia[@]}]${end}"
                bet=$((${mi_secuencia[0]} + ${mi_secuencia[-1]}))
            fi
        fi
    fi

    # sleep 1
    done
    tput cnorm
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
    elif [ "$tecnica" == "inverseLabrouchere" ]; then
        inverseLabrouchere
    else
        echo -e "\n${colorRojo}[!] La tecnica introducida no existe${end}"
        helpPanel
    fi 
else
    helpPanel
fi
