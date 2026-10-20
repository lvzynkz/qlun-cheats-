#!/data/data/com.termux/files/usr/bin/bash

# ===== CORES =====
AZUL="\e[34m"
G="\e[32m"
Y="\e[33m"
R="\e[31m"
N="\e[0m"

# ===== FUNÇÕES =====

ver_clima() {
    clear
    echo -e "${AZUL}=== PREVISAO DO TEMPO (OPEN-METEO) ===${N}\n"
    read -p "Digite a cidade (ex: Feira de Santana): " cidade
    if [[ -z "$cidade" ]]; then return; fi
    
    echo -e "\n${Y}Buscando dados para '$cidade'...${N}"
    
    RESULTADO=$(python -c '
import sys, json, urllib.request, urllib.parse
cidade = sys.argv[1]
try:
    cidade_encoded = urllib.parse.quote(cidade)
    geo_url = f"https://geocoding-api.open-meteo.com/v1/search?name={cidade_encoded}&count=1&language=pt&format=json"
    with urllib.request.urlopen(geo_url, timeout=5) as resp:
        geo_data = json.loads(resp.read().decode())
    if "results" not in geo_data:
        print("ERRO_CIDADE")
        sys.exit()
    lat = geo_data["results"][0]["latitude"]
    lon = geo_data["results"][0]["longitude"]
    nome_limpo = geo_data["results"][0]["name"]
    clima_url = f"https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current_weather=true"
    with urllib.request.urlopen(clima_url, timeout=5) as resp:
        clima_data = json.loads(resp.read().decode())
    temp = clima_data["current_weather"]["temperature"]
    vento = clima_data["current_weather"]["windspeed"]
    print(f"OK|{nome_limpo}|{temp}|{vento}")
except Exception:
    print("ERRO_API")
' "$cidade")
    
    if [[ "$RESULTADO" == "ERRO_CIDADE" ]]; then
        echo -e "${R}[!] Cidade nao encontrada. Tente sem acentos.${N}"
    elif [[ "$RESULTADO" == "ERRO_API" ]]; then
        echo -e "${R}[!] Erro ao conectar na API. Verifique sua internet.${N}"
    else
        NOME_REAL=$(echo "$RESULTADO" | cut -d'|' -f2)
        TEMP=$(echo "$RESULTADO" | cut -d'|' -f3)
        VENTO=$(echo "$RESULTADO" | cut -d'|' -f4)
        echo -e "\n${G}[+] Clima em $NOME_REAL${N}"
        echo -e "  Temperatura: ${Y}${TEMP}°C${N}"
        echo -e "  Vento:       ${Y}${VENTO} km/h${N}"
    fi
    read -p "Enter para voltar..."
}

converter_moeda() {
    clear
    echo -e "${AZUL}=== CONVERSOR DE MOEDAS (TEMPO REAL) ===${N}\n"
    echo -e "${Y}Buscando cotacoes atuais (USD e EUR para BRL)...${N}\n"
    
    COTACOES=$(python -c '
import urllib.request, json
try:
    req = urllib.request.urlopen("https://economia.awesomeapi.com.br/last/USD-BRL,EUR-BRL", timeout=5)
    data = json.loads(req.read().decode())
    usd = data["USDBRL"]["bid"]
    eur = data["EURBRL"]["bid"]
    print(f"{usd} {eur}")
except Exception:
    print("ERRO")
')
    
    if [[ "$COTACOES" == "ERRO" || -z "$COTACOES" ]]; then
        echo -e "${R}[!] Nao foi possivel consultar as cotacoes.${N}"
        read -p "Enter para voltar..."
        return
    fi
    
    USD=$(echo "$COTACOES" | cut -d' ' -f1)
    EUR=$(echo "$COTACOES" | cut -d' ' -f2)
    
    echo -e "  Dolar (USD) hoje: ${G}R$ $USD${N}"
    echo -e "  Euro (EUR) hoje:  ${G}R$ $EUR${N}"
    
    echo -e "\n${Y}Quer converter um valor?${N}"
    read -p "Digite o valor em Real (ex: 5,50 ou Enter para sair): " real
    
    if [[ -n "$real" ]]; then
        REAL_FORMAT=$(echo "$real" | sed 's/,/./g')
        RESULTADO=$(python -c "
try:
    r = float('$REAL_FORMAT')
    u = float('$USD')
    e = float('$EUR')
    print(f'  R\$ {r:.2f} = {r / u:.2f} US\$')
    print(f'  R\$ {r:.2f} = {r / e:.2f} EUR')
except Exception:
    print('  Erro: Digite apenas numeros.')
")
        echo -e "\n${G}$RESULTADO${N}"
    fi
    read -p "Enter para voltar..."
}

info_data_hora() {
    clear
    echo -e "${AZUL}=== DATA E HORA ===${N}\n"
    echo -e "${Y}Data e hora do sistema:${N}"
    date "+%A, %d de %B de %Y - %H:%M:%S"
    echo -e "\n${Y}Calendario do mes atual:${N}"
    cal 2>/dev/null || echo "Comando 'cal' nao instalado (pkg install util-linux)"
    read -p "Enter para voltar..."
}

calculadora_rede() {
    clear
    echo -e "${AZUL}=== CALCULADORA DE REDE (PYTHON) ===${N}\n"
    read -p "Informe o IP e Mascara (ex: 192.168.0.10/24): " ip_cidr
    if [[ -z "$ip_cidr" ]]; then return; fi
    
    echo -e "\n${Y}Calculando...${N}\n"
    python -c "
import ipaddress, sys
try:
    net = ipaddress.ip_network(sys.argv[1], strict=False)
    print(f'  Rede:       {net.network_address}')
    print(f'  Broadcast:  {net.broadcast_address}')
    print(f'  Mascara:    {net.netmask}')
    print(f'  Hosts:      {net.num_addresses - 2 if net.num_addresses > 2 else net.num_addresses}')
except Exception as e:
    print('  Erro: IP ou formato invalido.')
" "$ip_cidr"
    read -p "Enter para voltar..."
}

# ===== LOOP DO MODULO =====
while true; do
    clear
    echo -e "${AZUL}UTILIDADES${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Previsao do Tempo"
    echo -e "      ${Y}-> Clima e vento precisos (Open-Meteo)${N}"
    echo -e "  ${AZUL}[2]${N} Conversor de Moedas"
    echo -e "      ${Y}-> Dolar e Euro em tempo real${N}"
    echo -e "  ${AZUL}[3]${N} Data, Hora e Calendario"
    echo -e "      ${Y}-> Relogio do sistema e calendario mensal${N}"
    echo -e "  ${AZUL}[4]${N} Calculadora de Rede (IP)"
    echo -e "      ${Y}-> Rede, Broadcast, Mascara e Hosts${N}"
    echo -e "  ${AZUL}[0]${N} Voltar ao Menu Principal"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt

    case $opt in
        1) ver_clima ;;
        2) converter_moeda ;;
        3) info_data_hora ;;
        4) calculadora_rede ;;
        0) exit 0 ;;
        *) echo -e "${R}Opcao invalida!${N}"; sleep 1 ;;
    esac
done
