#!/data/data/com.termux/files/usr/bin/bash
AZUL="\e[34m"; G="\e[32m"; Y="\e[33m"; R="\e[31m"; N="\e[0m"

gerar_nick() {
    clear
    echo -e "${AZUL}=== GERADOR DE NICK PRO ===${N}\n"
    echo -e "  ${AZUL}[1]${N} Free Fire (Tryhard)"
    echo -e "  ${AZUL}[2]${N} Discord/TikTok (Clean)"
    echo -e "  ${AZUL}[3]${N} Aleatório (Letras/Números)"
    read -p "  ➜ Estilo: " est
    
    case $est in
        1) PRE=("Xx_" "•" "︻デ" "FF_" "SNIPER_"); NOM=("Capa" "GOD" "Rush" "Xit"); SUF=("_xX" "彡" "01" "YT")
           echo -e "\n${G}${PRE[$RANDOM%5]}${NOM[$RANDOM%4]}${SUF[$RANDOM%4]}$((RANDOM%99))${N}" ;;
        2) NOM=("ghost" "void" "neon" "cyber" "toxic"); SUF=(".exe" "_" ".gg" "xd")
           echo -e "\n${G}${NOM[$RANDOM%5]}${SUF[$RANDOM%4]}${N}" ;;
        3) tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8 | echo -e "\n${G}$(cat)${N}" ;;
        *) return ;;
    esac
    read -p "Enter para voltar..."
}

gerar_tag_equipe() {
    clear
    echo -e "${AZUL}=== GERADOR DE TAG / EQUIPE ===${N}\n"
    TAGS=("FF" "BR" "OP" "GG" "XE" "GOD" "VIT" "TOP" "VIP" "Z")
    A=${TAGS[$RANDOM%10]}; B=${TAGS[$RANDOM%10]}
    echo -e "Tag de Cla:    ${G}[${A}]${N} ou ${G}[${B}]${N}"
    echo -e "Nome de Equipe: ${G}Team ${A}${B}${N}"
    echo -e "Slogan:         ${G}\"Jogue limpo, vença sujo.\"${N}"
    read -p "Enter para voltar..."
}

validar_nick() {
    clear
    echo -e "${AZUL}=== VALIDADOR DE FORMATO ===${N}\n"
    echo -e "${Y}Regras: 3 a 16 caracteres. Apenas letras, numeros e _ (underline).${N}"
    read -p "Digite o nick: " nick
    if [[ "$nick" =~ ^[a-zA-Z0-9_]{3,16}$ ]]; then
        echo -e "\n${G}[+] Formato VALIDO! O nick nao tem espacos ou caracteres proibidos.${N}"
    else
        echo -e "\n${R}[!] Formato INVALIDO! Verifique o tamanho e os caracteres.${N}"
    fi
    read -p "Enter para voltar..."
}

while true; do
    clear
    echo -e "${AZUL}GAMER IDENTITY${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Gerador de Nick"
    echo -e "  ${AZUL}[2]${N} Gerador de Tag / Equipe / Slogan"
    echo -e "  ${AZUL}[3]${N} Validador de Formato de Nick"
    echo -e "  ${AZUL}[0]${N} Voltar"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt
    case $opt in
        1) gerar_nick ;; 2) gerar_tag_equipe ;; 3) validar_nick ;; 0) exit 0 ;;
    esac
done
