#!/data/data/com.termux/files/usr/bin/bash

AZUL="\e[34m"
G="\e[32m"
Y="\e[33m"
R="\e[31m"
N="\e[0m"

aplicar_bloqueio() {
    clear
    echo -e "${AZUL}=== ATIVAR BLOQUEIO ANTI-KELLER ===${N}\n"
    echo -e "${Y}Isso vai bloquear o download do KellerSS e apagar arquivos existentes.${N}"
    read -p "Tem certeza que quer ativar? (s/n): " conf
    if [[ "$conf" != "s" && "$conf" != "S" ]]; then return; fi

    # Deleta arquivos antigos
    echo -e "\n${R}Limpando arquivos antigos...${N}"
    rm -f "$HOME/KellerSS" 2>/dev/null
    rm -rf "$HOME/KellerSS-Android" 2>/dev/null

    # Remove bloqueio antigo se existir
    sed -i '/--- INICIO BLOQUEIO KELLER ---/,/--- FIM BLOQUEIO KELLER ---/d' $HOME/.bashrc

    # Cria o bloqueio agressivo no .bashrc
    echo "# --- INICIO BLOQUEIO KELLER ---" >> $HOME/.bashrc
    
    # 1. Bloqueia o download via curl se a URL tiver 'keller'
    echo 'curl() {' >> $HOME/.bashrc
    echo '    if [[ "$@" == *"keller"* ]]; then' >> $HOME/.bashrc
    echo '        echo -e "\e[31m[!] Ops... Repositorio Keller bloqueado. ( T_T )\e[0m"' >> $HOME/.bashrc
    echo '        return 1' >> $HOME/.bashrc
    echo '    else' >> $HOME/.bashrc
    echo '        command curl "$@"' >> $HOME/.bashrc
    echo '    fi' >> $HOME/.bashrc
    echo '}' >> $HOME/.bashrc

    # 2. Deleta o arquivo se ele já existir (por segurança)
    echo 'if [ -f "$HOME/KellerSS" ]; then' >> $HOME/.bashrc
    echo '    rm -f "$HOME/KellerSS" 2>/dev/null' >> $HOME/.bashrc
    echo 'fi' >> $HOME/.bashrc
    
    # 3. Bloqueia a execução direta
    echo 'alias KellerSS="clear; echo -e \"\e[31m[!] Ops... Repositorio Keller bloqueado. ( T_T )\e[0m\""' >> $HOME/.bashrc
    echo "# --- FIM BLOQUEIO KELLER ---" >> $HOME/.bashrc

    echo -e "\n${G}[+] BLOQUEIO ATIVADO!${N}"
    echo -e "Agora o comando dele nem vai conseguir baixar o arquivo."
    echo -e "${Y}Feche e abra o Termux, ou rode 'source ~/.bashrc' para ativar.${N}"
    read -p "Enter para voltar..."
}

desativar_bloqueio() {
    clear
    echo -e "${AZUL}=== DESATIVAR BLOQUEIO ===${N}\n"
    read -p "Quer tirar o bloqueio do sistema? (s/n): " conf
    if [[ "$conf" == "s" || "$conf" == "S" ]]; then
        sed -i '/--- INICIO BLOQUEIO KELLER ---/,/--- FIM BLOQUEIO KELLER ---/d' $HOME/.bashrc
        echo -e "\n${G}[+] Bloqueio removido.${N}"
    else
        echo -e "\nOperacao cancelada."
    fi
    read -p "Enter para voltar..."
}

verificar_status() {
    clear
    echo -e "${AZUL}=== STATUS DO BLOQUEIO ===${N}\n"
    if grep -q "INICIO BLOQUEIO KELLER" $HOME/.bashrc; then
        echo -e "  Status: ${R}ATIVO (Modo Paranoico)${N}"
    else
        echo -e "  Status: ${G}INATIVO${N}"
    fi
    read -p "Enter para voltar..."
}

while true; do
    clear
    echo -e "${AZUL}ANTI-KELLER (BLOQUEADOR)${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Ativar Bloqueio"
    echo -e "  ${AZUL}[2]${N} Desativar Bloqueio"
    echo -e "  ${AZUL}[3]${N} Ver Status Atual"
    echo -e "  ${AZUL}[0]${N} Voltar"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt
    case $opt in
        1) aplicar_bloqueio ;;
        2) desativar_bloqueio ;;
        3) verificar_status ;;
        0) exit 0 ;;
    esac
done
