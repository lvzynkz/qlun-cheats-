#!/data/data/com.termux/files/usr/bin/bash

# ===== CORES =====
AZUL="\e[34m"
N="\e[0m"

# ===== BANNER =====
banner() {
    clear
    echo -e "${AZUL}"
    cat << 'EOF'
< qlun cheats >
 ------------
    \
     \
   .!!!!!!:               .!!!!!!!!:.
  ~~~!!!!!!!       ...    :!!!!!!!!!UWW$$$$$$$P
    $$$NWX!!     . .:!!!!!XUW$$$$$$$$$
    $$$$$##WX!:  .:!!UW$$$$$$$$$  4$$$$$$$#
    $$$$$   $$UX :!!UW$$$$$$$$$  4$$$$$$$*
    ^$$$B  $$$$\ $$$$$$$$$$$$$   d$$$R"
     "*$bd$$$$    '*$$$$$$$$$$o+#"
       """"""      """""""""""

   ___  _     _   _   _    ____ _   _ _____    _  _____ ____
  / _ \| |   | | | \ | |  / ___| | | | ____|  / \|_   _/ ___|
 | | | | |   | | |  \| | | |   | |_| |  _|   / _ \ | | \___ \
 | |_| | |___| |_| |\  | | |___|  _  | |___ / ___ \| |  ___) |
  \__\_\\____/|_|_| \_|  \____|_| |_|_____/_/   \_\_| |____/
EOF
    echo -e "${N}"
}

# ===== LOOP DO MENU =====
while true; do
    banner
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}CATEGORIAS${N}"
    echo -e "  ${AZUL}[1]${N} 🐧 Linux & Terminal"
    echo -e "  ${AZUL}[2]${N} 🧹 Limpeza Profunda"
    echo -e "  ${AZUL}[3]${N} 🌐 Rede & Diagnóstico"
    echo -e "  ${AZUL}[4]${N} 🎮 Gaming Tools"
    echo -e "  ${AZUL}[5]${N} 💻 Dev & Segurança"
    echo -e "  ${AZUL}[6]${N} 🧰 Utilidades"
    echo -e "  ${AZUL}[7]${N} 🚪 Sair"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opção: " opt

    case $opt in
        1) bash modules/linux.sh ;;
        2) bash modules/cleaner.sh ;;
        3) bash modules/rede.sh ;;
        4) bash modules/gaming.sh ;;
        5) bash modules/devtools.sh ;;
        6) bash modules/utilidades.sh ;;
        7) echo -e "\n  ${AZUL}Falou! 👋${N}"; exit 0 ;;
        *) echo -e "\n  ${AZUL}Opção inválida!${N}"; sleep 1 ;;
    esac
done
