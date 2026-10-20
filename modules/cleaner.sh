#!/data/data/com.termux/files/usr/bin/bash

# ===== CORES =====
AZUL="\e[34m"
G="\e[32m"
Y="\e[33m"
R="\e[31m"
N="\e[0m"

# ===== FUNÇÕES =====

verificar_armazenamento() {
    clear
    echo -e "${AZUL}=== ANALISE DE ARMAZENAMENTO ===${N}\n"
    
    echo -e "${Y}[*] Espaco em /data (Sistema/Termux):${N}"
    df -h /data | tail -1 | awk '{print "Total: "$2" | Usado: "$3" | Livre: "$4}'
    
    echo -e "\n${Y}[*] Espaco em /sdcard (Armazenamento Interno):${N}"
    if [ -d "/sdcard" ]; then
        df -h /sdcard | tail -1 | awk '{print "Total: "$2" | Usado: "$3" | Livre: "$4}'
    else
        echo -e "${R}[!] Acesso ao /sdcard negado.${N}"
        echo -e "    Rode 'termux-setup-storage' e permita o acesso."
        read -p "Enter para voltar..."
        return
    fi

    echo -e "\n${Y}[*] Top 5 maiores pastas em /sdcard (pode demorar um pouco):${N}"
    timeout 5 du -h -d 1 /sdcard/ 2>/dev/null | sort -rh | head -n 5
    
    read -p "Enter para voltar..."
}

limpar_termux() {
    clear
    echo -e "${AZUL}=== LIMPEZA DO TERMUX (SEGURO) ===${N}\n"
    echo -e "${Y}Aviso: Isso apaga apenas os arquivos .deb de instalacao.${N}"
    echo -e "${Y}Seu Linux (proot) e pacotes instalados NAO serao afetados.${N}\n"
    
    TAMANHO_ANTES=$(du -sh $PREFIX/var/cache 2>/dev/null | awk '{print $1}')
    echo -e "Tamanho atual do cache: ${Y}${TAMANHO_ANTES:-0B}${N}"
    
    read -p "Deseja limpar o cache de pacotes? (s/n): " confirm
    if [[ "$confirm" == "s" || "$confirm" == "S" ]]; then
        rm -rf $PREFIX/var/cache/* 2>/dev/null
        TAMANHO_DEPOIS=$(du -sh $PREFIX/var/cache 2>/dev/null | awk '{print $1}')
        echo -e "\n${G}[+] Cache do Termux limpo com sucesso!${N}"
        echo -e "Espaco antes: ${Y}$TAMANHO_ANTES${N} | Agora: ${G}${TAMANHO_DEPOIS:-0B}${N}"
    else
        echo -e "\nOperacao cancelada."
    fi
    read -p "Enter para voltar..."
}

apagar_antigos() {
    clear
    echo -e "${AZUL}=== APAGAR ARQUIVOS ANTIGOS EM DOWNLOADS ===${N}\n"
    
    if [ ! -d "/sdcard/Download" ]; then
        echo -e "${R}[!] Pasta Download nao encontrada ou acesso negado.${N}"
        read -p "Enter para voltar..."
        return
    fi

    QTD=$(find /sdcard/Download -maxdepth 1 -type f -mtime +30 2>/dev/null | wc -l)
    
    if [ "$QTD" -eq 0 ]; then
        echo -e "${G}[+] Nenhum arquivo com mais de 30 dias encontrado.${N}"
        read -p "Enter para voltar..."
        return
    fi

    echo -e "${Y}Foram encontrados $QTD arquivos com mais de 30 dias.${N}"
    echo -e "Amostra do que sera apagado:"
    find /sdcard/Download -maxdepth 1 -type f -mtime +30 -exec ls -lh {} \; 2>/dev/null | awk '{print " - " $9}' | head -n 10
    
    echo -e "\n${R}ATENCAO: Voce esta prestes a apagar esses $QTD arquivos!${N}"
    read -p "Digite 'SIM' (em maiusculo) para confirmar: " confirm
    
    if [ "$confirm" == "SIM" ]; then
        echo -e "\n${Y}Apagando arquivos...${N}"
        find /sdcard/Download -maxdepth 1 -type f -mtime +30 -delete 2>/dev/null
        
        QTD_DEPOIS=$(find /sdcard/Download -maxdepth 1 -type f -mtime +30 2>/dev/null | wc -l)
        if [ "$QTD_DEPOIS" -eq 0 ]; then
            echo -e "\n${G}[+] Limpeza concluida! $QTD arquivos foram apagados.${N}"
        else
            echo -e "\n${R}[!] Alguns arquivos nao puderam ser apagados (permissao do Android).${N}"
        fi
    else
        echo -e "\n${G}Operacao cancelada. Nenhum arquivo foi apagado.${N}"
    fi
    read -p "Enter para voltar..."
}

checar_root() {
    # Procura o binário 'su' no sistema
    SU_BIN=$(command -v su 2>/dev/null)
    
    if [ -n "$SU_BIN" ]; then
        echo -e "${G}[+] Root detectado no sistema!${N}"
        echo -e "    ${Y}-> Pacote/Arquivo: $SU_BIN${N}"
        
        # Verifica se é root real ou falso (de app de injeção)
        if su -c "id" 2>/dev/null | grep -q "uid=0"; then
            echo -e "    ${G}-> Status: Root Real (Magisk/KernelSU)${N}"
        else
            echo -e "    ${Y}-> Status: Possivel App de Injecao/Mod (falso)${N}"
        fi
    else
        echo -e "${R}[-] Root NAO detectado (Modo seguro).${N}"
    fi
}

# ===== LOOP DO MODULO =====
while true; do
    clear
    echo -e "${AZUL}ANDROID CLEANER${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    checar_root
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Analisar Armazenamento"
    echo -e "      ${Y}-> Ver espaco livre e pastas mais pesadas${N}"
    echo -e "  ${AZUL}[2]${N} Limpar Cache do Termux"
    echo -e "      ${Y}-> Apagar arquivos temporarios seguros${N}"
    echo -e "  ${AZUL}[3]${N} Apagar Arquivos Antigos (>30 dias)"
    echo -e "      ${Y}-> Limpar a pasta Downloads com confirmacao${N}"
    echo -e "  ${AZUL}[0]${N} Voltar ao Menu Principal"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt

    case $opt in
        1) verificar_armazenamento ;;
        2) limpar_termux ;;
        3) apagar_antigos ;;
        0) exit 0 ;;
        *) echo -e "${R}Opcao invalida!${N}"; sleep 1 ;;
    esac
done
