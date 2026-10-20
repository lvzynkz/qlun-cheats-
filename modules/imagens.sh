#!/data/data/com.termux/files/usr/bin/bash

AZUL="\e[34m"
G="\e[32m"
Y="\e[33m"
R="\e[31m"
N="\e[0m"

gerar_imagem() {
    clear
    echo -e "${AZUL}=== GERADOR DE IMAGENS IA (POLLINATIONS) ===${N}\n"
    echo -e "${Y}Descreva a imagem que voce quer criar.${N}"
    echo -e "${Y}Exemplo: Um gato cyberpunk usando oculos de sol neon, 4k${N}"
    read -p "➜ Prompt: " PROMPT
    
    if [[ -z "$PROMPT" ]]; then return; fi
    
    echo -e "\n${Y}[*] Processando prompt e solicitando imagem...${N}"
    echo -e "${Y}[*] Isso pode demorar de 5 a 15 segundos...${N}"
    
    # Usa o Python para codificar o texto
    PROMPT_URL=$(python -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$PROMPT")
    
    NOME_ARQ="qlun_ia_$(date +%s).jpg"
    CAMINHO_ARQ="/sdcard/Download/$NOME_ARQ"
    
    # Faz o download da API gratuita
    curl -s -L -o "$CAMINHO_ARQ" "https://image.pollinations.ai/prompt/${PROMPT_URL}?width=1024&height=1024&nologo=true"
    
    # Verifica se o arquivo foi criado
    if [ -f "$CAMINHO_ARQ" ] && [ -s "$CAMINHO_ARQ" ]; then
        echo -e "\n${G}[+] Imagem gerada com sucesso!${N}"
        echo -e "  Salva em: ${Y}$CAMINHO_ARQ${N}"
    else
        echo -e "\n${R}[!] Falha ao gerar a imagem.${N}"
        echo -e "  Verifique sua internet ou tente um prompt mais simples."
        rm -f "$CAMINHO_ARQ" 2>/dev/null
    fi
    
    echo ""
    read -p "Pressione Enter para voltar..."
}

while true; do
    clear
    echo -e "${AZUL}GERADOR DE IMAGENS IA${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} 🎨 Criar nova imagem"
    echo -e "      ${Y}-> Gera e salva a imagem na pasta Downloads${N}"
    echo -e "  ${AZUL}[0]${N} ↩  Voltar ao Menu Principal"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt
    case $opt in
        1) gerar_imagem ;;
        0) exit 0 ;;
        *) echo -e "${R}Opcao invalida!${N}"; sleep 1 ;;
    esac
done
