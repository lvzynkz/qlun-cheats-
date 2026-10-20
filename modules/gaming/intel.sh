#!/data/data/com.termux/files/usr/bin/bash
AZUL="\e[34m"; G="\e[32m"; Y="\e[33m"; R="\e[31m"; N="\e[0m"
CONFIG="$(dirname "$0")/config.sh"

# Carrega a chave da RAWG se existir
[ -f "$CONFIG" ] && source "$CONFIG"

steam_live() {
    clear
    echo -e "${AZUL}=== STEAM: JOGADORES AO VIVO ===${N}\n"
    echo -e "${Y}Digite o nome do jogo (ex: Counter-Strike, Dota, Rust)${N}"
    read -p "➜ " JOGO
    [ -z "$JOGO" ] && return
    
    JOGO_URL=$(echo "$JOGO" | sed 's/ /%20/g')
    echo -e "\n${Y}Buscando na Steam...${N}"
    
    APPID=$(curl -s "https://store.steampowered.com/api/storesearch/?term=$JOGO_URL&l=portuguese&cc=BR" | grep -o '"id":[0-9]*' | head -1 | cut -d: -f2)
    
    if [ -z "$APPID" ]; then
        echo -e "${R}[!] Jogo nao encontrado na Steam.${N}"
        read -p "Enter..."; return
    fi
    
    RES=$(curl -s --max-time 5 "https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1/?appid=$APPID")
    PL=$(echo "$RES" | grep -o '"player_count":[0-9]*' | cut -d: -f2)
    
    if [ -n "$PL" ]; then
        echo -e "\n${G}[+] $JOGO${N}"
        echo -e "  Jogadores agora: ${G}$PL${N}"
        echo -e "  Fonte: Steam Web API (Ao vivo)"
    else
        echo -e "\n${R}[!] Nao foi possivel pegar os dados.${N}"
    fi
    read -p "Enter para voltar..."
}

rawg_search() {
    clear
    echo -e "${AZUL}=== RAWG: BANCO DE JOGOS ===${N}\n"
    
    if [ -z "$RAWG_API_KEY" ]; then
        echo -e "${Y}A RAWG API exige uma chave gratuita.${N}"
        echo -e "Pegue a sua em: https://rawg.io/apidocs"
        read -p "Cole sua chave aqui: " KEY
        if [ -n "$KEY" ]; then
            echo "export RAWG_API_KEY=\"$KEY\"" > "$CONFIG"
            export RAWG_API_KEY="$KEY"
            echo -e "${G}[+] Chave salva com seguranca!${N}"
        else
            return
        fi
    fi

    read -p "Pesquisar jogo: " GAME
    [ -z "$GAME" ] && return
    
    GAME_URL=$(echo "$GAME" | sed 's/ /%20/g')
    echo -e "\n${Y}Consultando RAWG...${N}"
    
    RES=$(curl -s "https://api.rawg.io/api/games?key=$RAWG_API_KEY&search=$GAME_URL&page_size=3")
    
    # Extrai Nome, Lancamento e Metacritic (se tiver)
    echo "$RES" | grep -o '"name":"[^"]*' | cut -d'"' -f4 | while read -r nome; do
        echo -e "  ${G}->${N} $nome"
    done
    
    echo -e "\n${Y}(Dados puxados ao vivo da RAWG)${N}"
    read -p "Enter para voltar..."
}

while true; do
    clear
    echo -e "${AZUL}GAMER INTELLIGENCE${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Jogadores Online (Steam)"
    echo -e "      ${Y}-> Puxa dados reais de qualquer jogo da Steam${N}"
    echo -e "  ${AZUL}[2]${N} Pesquisar Jogo (RAWG)"
    echo -e "      ${Y}-> Busca nome e detalhes no banco de dados${N}"
    echo -e "  ${AZUL}[0]${N} Voltar"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt
    case $opt in
        1) steam_live ;;
        2) rawg_search ;;
        0) exit 0 ;;
    esac
done
