#!/data/data/com.termux/files/usr/bin/bash
AZUL="\e[34m"; G="\e[32m"; Y="\e[33m"; R="\e[31m"; N="\e[0m"

check_deps() {
    if ! command -v termux-battery-status &>/dev/null; then
        echo -e "${R}[!] O pacote 'termux-api' nao esta instalado.${N}"
        echo -e "${Y}Instalando...${N}"
        pkg install termux-api -y
    fi
}

device_check() {
    clear
    echo -e "${AZUL}=== STATUS DO DISPOSITIVO ===${N}\n"
    
    MODELO=$(getprop ro.product.model 2>/dev/null)
    ANDROID=$(getprop ro.build.version.release 2>/dev/null)
    ARCH=$(uname -m)
    
    echo -e "${Y}Modelo:${N}  $MODELO"
    echo -e "${Y}Android:${N} $ANDROID"
    echo -e "${Y}Arch:${N}    $ARCH"
    
    echo -e "\n${Y}Memoria RAM (Linux):${N}"
    free -h | awk '/Mem:/ {print "  Usada: "$3" | Livre: "$4" | Total: "$2}'
    
    echo -e "\n${Y}Armazenamento (/data):${N}"
    df -h /data | tail -1 | awk '{print "  Usado: "$3" | Livre: "$4}'
    
    read -p "Enter para voltar..."
}

performance_monitor() {
    clear
    check_deps
    echo -e "${AZUL}=== PERFORMANCE E TEMPERATURA ===${N}\n"
    
    # Puxa os dados do termux-api
    BATERIA_JSON=$(termux-battery-status 2>/dev/null)
    TEMP=$(echo "$BATERIA_JSON" | grep -o '"temperature":[0-9.]*' | cut -d: -f2)
    NIVEL=$(echo "$BATERIA_JSON" | grep -o '"percentage":[0-9]*' | cut -d: -f2)
    
    echo -e "${Y}Bateria:${N}       ${G}${NIVEL:-?}%${N}"
    echo -e "${Y}Temperatura:${N}   ${G}${TEMP:-?}°C${N}"
    
    # Verifica se a temp está alta (mais de 40 graus)
    if [ -n "$TEMP" ] && (( $(echo "$TEMP > 40.0" | bc -l) )); then
        echo -e "  ${R}[!] ALERTA: Celular quente! Pode dar lag nos jogos.${N}"
    fi
    
    echo -e "\n${Y}Uso de CPU (Top 3 processos):${N}"
    top -b -n 1 | head -n 10 | tail -n 5
    
    read -p "Enter para voltar..."
}

limpar_cache() {
    clear
    echo -e "${AZUL}=== STORAGE OPTIMIZER ===${N}\n"
    
    TAM_ANTES=$(df -h /data | tail -1 | awk '{print $4}')
    echo -e "Espaco livre atual: ${Y}$TAM_ANTES${N}"
    
    read -p "Deseja limpar o cache de instalacao do Termux? (s/n): " CONF
    if [[ "$CONF" == "s" || "$CONF" == "S" ]]; then
        rm -rf $PREFIX/var/cache/* 2>/dev/null
        TAM_DEPOIS=$(df -h /data | tail -1 | awk '{print $4}')
        echo -e "\n${G}[+] Cache limpo!${N}"
        echo -e "Espaco depois: ${G}$TAM_DEPOIS${N}"
    else
        echo -e "\nCancelado."
    fi
    read -p "Enter para voltar..."
}

while true; do
    clear
    echo -e "${AZUL}OTIMIZADOR ANDROID${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Status do Dispositivo"
    echo -e "      ${Y}-> Modelo, RAM e Armazenamento${N}"
    echo -e "  ${AZUL}[2]${N} Monitor de Performance"
    echo -e "      ${Y}-> Temperatura, Bateria e Top Processos${N}"
    echo -e "  ${AZUL}[3]${N} Limpar Cache Seguro"
    echo -e "      ${Y}-> Liberar espaco no Termux${N}"
    echo -e "  ${AZUL}[0]${N} Voltar"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt
    case $opt in
        1) device_check ;;
        2) performance_monitor ;;
        3) limpar_cache ;;
        0) exit 0 ;;
    esac
done
