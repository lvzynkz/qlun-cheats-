#!/data/data/com.termux/files/usr/bin/bash
AZUL="\e[34m"; G="\e[32m"; Y="\e[33m"; R="\e[31m"; N="\e[0m"

status_mc() {
    clear
    echo -e "${AZUL}=== MINECRAFT STATUS (JAVA) ===${N}\n"
    read -p "IP do Servidor (ex: play.hypixel.net): " ip
    [ -z "$ip" ] && return
    
    echo -e "\n${Y}Consultando API...${N}"
    RES=$(curl -s --max-time 5 "https://api.mcstatus.io/v2/status/java/$ip")
    if [[ "$RES" == *"online"*"true"* ]]; then
        PL=$(echo "$RES" | grep -o '"online_players":[0-9]*' | head -1 | cut -d: -f2)
        echo -e "\n${G}[+] $ip ONLINE!${N}"
        echo -e "  Players: ${G}${PL:-0}${N}"
    else
        echo -e "\n${R}[!] Servidor OFFLINE ou inacessivel.${N}"
    fi
    read -p "Enter..."
}

ping_custom() {
    clear
    echo -e "${AZUL}=== PING DE SERVIDOR ===${N}\n"
    read -p "IP ou URL (ex: google.com): " alvo
    [ -z "$alvo" ] && return
    
    echo -e "\n${Y}Enviando 4 pacotes...${N}\n"
    ping -c 4 "$alvo"
    read -p "Enter..."
}

scan_porta() {
    clear
    echo -e "${AZUL}=== CHECAR PORTA (GameDig Fallback) ===${N}\n"
    echo -e "${Y}Use para checar se um servidor de jogo esta com a porta aberta.${N}"
    read -p "IP do servidor: " ip
    read -p "Porta (ex: 25565, 27015): " porta
    
    if [ -z "$ip" ] || [ -z "$porta" ]; then return; fi
    
    echo -e "\n${Y}Testando $ip na porta $porta...${N}"
    # Usa o /dev/tcp do Bash para testar conexao
    timeout 3 bash -c "echo > /dev/tcp/$ip/$porta" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${G}[+] PORTA ABERTA! O servidor esta rodando.${N}"
    else
        echo -e "${R}[!] PORTA FECHADA ou Timeout.${N}"
    fi
    read -p "Enter..."
}

while true; do
    clear
    echo -e "${AZUL}SERVER TOOLS PRO${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Status Minecraft (API Oficial)"
    echo -e "  ${AZUL}[2]${N} Ping de Servidor (Latência)"
    echo -e "  ${AZUL}[3]${N} Checar Porta de Jogo (TCP)"
    echo -e "  ${AZUL}[4]${N} Comparar Latência (Em breve)"
    echo -e "  ${AZUL}[0]${N} Voltar"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt
    case $opt in
        1) status_mc ;; 2) ping_custom ;; 3) scan_porta ;; 
        4) echo -e "\n${Y}[!] Em breve...${N}"; sleep 1 ;;
        0) exit 0 ;;
    esac
done
