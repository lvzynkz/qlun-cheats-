#!/data/data/com.termux/files/usr/bin/bash

# ===== CORES =====
AZUL="\e[34m"
G="\e[32m"
Y="\e[33m"
R="\e[31m"
N="\e[0m"

# ===== FUNÇÕES =====

testar_ping() {
    clear
    echo -e "${AZUL}=== TESTE DE PING (GOOGLE) ===${N}\n"
    echo -e "${Y}Enviando 4 pacotes para google.com...${N}\n"
    
    if ping -c 4 google.com; then
        echo -e "\n${G}[+] Conexao estabelecida com sucesso.${N}"
    else
        echo -e "\n${R}[!] Falha no ping. Verifique sua conexao.${N}"
    fi
    read -p "Enter para voltar..."
}

ver_ip_publico() {
    clear
    echo -e "${AZUL}=== SEU IP PUBLICO ===${N}"
    
    if ! command -v curl &>/dev/null; then
        echo -e "${R}[!] O comando 'curl' nao esta instalado.${N}"
        read -p "Enter para voltar..."
        return
    fi
    
    echo -e "${Y}Consultando API externa (ipinfo.io)...${N}\n"
    RESPOSTA=$(curl -s --max-time 5 "https://ipinfo.io/json")
    
    if [ -n "$RESPOSTA" ]; then
        IP=$(echo "$RESPOSTA" | grep -o '"ip": "[^"]*' | cut -d'"' -f4)
        CIDADE=$(echo "$RESPOSTA" | grep -o '"city": "[^"]*' | cut -d'"' -f4)
        REGIAO=$(echo "$RESPOSTA" | grep -o '"region": "[^"]*' | cut -d'"' -f4)
        PAIS=$(echo "$RESPOSTA" | grep -o '"country": "[^"]*' | cut -d'"' -f4)
        PROVEDOR=$(echo "$RESPOSTA" | grep -o '"org": "[^"]*' | cut -d'"' -f4)
        LOC=$(echo "$RESPOSTA" | grep -o '"loc": "[^"]*' | cut -d'"' -f4)
        
        echo -e "  IP:       ${G}$IP${N}"
        echo -e "  Cidade:   ${G}${CIDADE:-Desconhecida}${N}"
        echo -e "  Regiao:   ${G}${REGIAO:-Desconhecida}${N}"
        echo -e "  Pais:     ${G}${PAIS:-Desconhecido}${N}"
        echo -e "  Provedor: ${G}${PROVEDOR:-Desconhecido}${N}"
        
        if [ -n "$LOC" ]; then
            LAT=$(echo "$LOC" | cut -d',' -f1)
            LON=$(echo "$LOC" | cut -d',' -f2)
            
            LINK_MAPS="https://www.google.com/maps?q=${LAT},${LON}"
            echo -e "\n${G}[+] Link do Google Maps gerado!${N}"
            echo -e "Copie ou clique no link abaixo para abrir no mapa:"
            echo -e "${AZUL}${LINK_MAPS}${N}"
            
            echo -e "\n${Y}NOTA IMPORTANTE:${N}"
            echo -e "${Y}O IP mostra a localizacao do servidor da sua operadora,${N}"
            echo -e "${Y}nao o seu endereco exato. Por isso o ponto pode variar.${N}"
        fi
    else
        echo -e "${R}[!] Nao foi possivel consultar o IP (Sem internet ou API fora do ar).${N}"
    fi
    read -p "Enter para voltar..."
}

testar_site() {
    clear
    echo -e "${AZUL}=== TESTE HTTP DE SITE ===${N}\n"
    read -p "Digite a URL (ex: discord.com): " url
    
    if [[ -z "$url" ]]; then
        echo -e "${R}URL invalida.${N}"; sleep 1; return
    fi

    # Remove http:// ou https:// se o usuario digitar
    url=$(echo "$url" | sed 's~http[s]*://~~g')

    echo -e "\n${Y}Verificando https://$url...${N}"
    
    # O -L segue redirecionamentos (ex: discord.cm -> discord.com)
    # O %{url_effective} mostra para onde o site realmente foi
    RESULTADO=$(curl -L -o /dev/null -s -w "%{http_code}|%{url_effective}" --max-time 5 "https://$url")
    
    STATUS=$(echo "$RESULTADO" | cut -d'|' -f1)
    URL_FINAL=$(echo "$RESULTADO" | cut -d'|' -f2)
    
    if [ "$STATUS" -eq 200 ]; then
        echo -e "${G}[+] Site ONLINE! Status HTTP: $STATUS${N}"
        echo -e "  URL Final: ${Y}$URL_FINAL${N}"
        
        # Aviso se o site redirecionou para outro lugar
        if [[ "$URL_FINAL" != *"$url"* ]]; then
            echo -e "\n${R}[!] ATENCAO: O site redirecionou para outro lugar!${N}"
            echo -e "    Voce digitou '$url', mas ele foi para '$URL_FINAL'."
        fi
    elif [ "$STATUS" -eq 000 ]; then
        echo -e "${R}[!] Falha na conexao. Site nao encontrado ou sem internet.${N}"
    else
        echo -e "${Y}[!] Site respondeu, mas com status HTTP: $STATUS (Pode estar fora do ar)${N}"
    fi
    read -p "Enter para voltar..."
}

# ===== LOOP DO MODULO =====
while true; do
    clear
    echo -e "${AZUL}REDE & DIAGNOSTICO${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Teste de Ping"
    echo -e "      ${Y}-> Verificar latencia e conexao com o Google${N}"
    echo -e "  ${AZUL}[2]${N} IP Publico e Localizacao"
    echo -e "      ${Y}-> IP, Cidade, Provedor e Link do Google Maps${N}"
    echo -e "  ${AZUL}[3]${N} Testar Status de um Site"
    echo -e "      ${Y}-> Ver se o site esta online e se redireciona${N}"
    echo -e "  ${AZUL}[0]${N} Voltar ao Menu Principal"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt

    case $opt in
        1) testar_ping ;;
        2) ver_ip_publico ;;
        3) testar_site ;;
        0) exit 0 ;;
        *) echo -e "${R}Opcao invalida!${N}"; sleep 1 ;;
    esac
done
