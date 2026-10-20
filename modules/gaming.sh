#!/data/data/com.termux/files/usr/bin/bash
AZUL="\e[34m"; G="\e[32m"; Y="\e[33m"; R="\e[31m"; N="\e[0m"
DIR="$(dirname "$0")/gaming"

while true; do
    clear
    echo -e "${AZUL}GAMING TOOLS PRO${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Gamer Identity"
    echo -e "      ${Y}-> Nicks, tags, slogans e validadores${N}"
    echo -e "  ${AZUL}[2]${N} Server Tools Pro"
    echo -e "      ${Y}-> Minecraft, Ping e Portas TCP${N}"
    echo -e "  ${AZUL}[3]${N} Gamer Intelligence"
    echo -e "      ${Y}-> Steam ao vivo e Banco de Jogos (RAWG)${N}"
    echo -e "  ${AZUL}[4]${N} Otimizador Android"
    echo -e "      ${Y}-> Performance, Temperatura e Bateria${N}"
    echo -e "  ${AZUL}[0]${N} Voltar ao Menu Principal"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt

    case $opt in
        1) bash "$DIR/identity.sh" ;;
        2) bash "$DIR/server.sh" ;;
        3) bash "$DIR/intel.sh" ;;
        4) bash "$DIR/optimizer.sh" ;;
        0) exit 0 ;;
        *) echo -e "${R}Opcao invalida!${N}"; sleep 1 ;;
    esac
done
