#!/data/data/com.termux/files/usr/bin/bash

# ===== CORES =====
AZUL="\e[34m"
G="\e[32m"
Y="\e[33m"
R="\e[31m"
N="\e[0m"

# ===== FUNÇÕES =====

gerar_senha() {
    clear
    echo -e "${AZUL}=== GERADOR DE SENHAS FORTES ===${N}\n"
    read -p "Quantos caracteres deseja? (Padrao 16): " tam
    tam=${tam:-16} 
    
    echo -e "\n${Y}Gerando senha com $tam caracteres...${N}"
    SENHA=$(tr -dc 'A-Za-z0-9!@#$%^&*()_+' < /dev/urandom | head -c "$tam")
    
    echo -e "\n${G}Sua Senha:${N} ${AZUL}${SENHA}${N}"
    echo -e "\n${R}[!] Guarde em local seguro e nao compartilhe.${N}"
    read -p "Enter para voltar..."
}

gerar_hash() {
    clear
    echo -e "${AZUL}=== HASH SHA-256 ===${N}\n"
    echo -e "Gera a 'impressao digital' de um texto (util para verificar integridade)."
    read -p "Digite o texto: " texto
    
    if [[ -z "$texto" ]]; then
        echo -e "${R}Texto vazio.${N}"; sleep 1; return
    fi

    echo -e "\n${Y}Calculando...${N}"
    HASH=$(echo -n "$texto" | sha256sum | awk '{print $1}')
    
    echo -e "\nHash SHA-256:"
    echo -e "${G}$HASH${N}"
    read -p "Enter para voltar..."
}

base64_tool() {
    clear
    echo -e "${AZUL}=== CODIFICADOR / DECODIFICADOR BASE64 ===${N}\n"
    echo -e "  ${AZUL}[1]${N} Codificar texto para Base64"
    echo -e "  ${AZUL}[2]${N} Decodificar Base64 para texto"
    echo -e "  ${AZUL}[0]${N} Cancelar"
    read -p "  ➜ Opcao: " opcao

    case $opcao in
        1)
            read -p "Digite o texto para codificar: " txt
            ENCODE=$(echo -n "$txt" | base64 -w 0)
            echo -e "\n${G}Codigo Base64:${N}\n$ENCODE"
            ;;
        2)
            read -p "Digite o codigo Base64: " b64
            DECODE=$(echo -n "$b64" | base64 -d 2>/dev/null)
            if [ -n "$DECODE" ]; then
                echo -e "\n${G}Texto Decodificado:${N}\n$DECODE"
            else
                echo -e "\n${R}[!] Base64 invalido ou corrompido.${N}"
            fi
            ;;
        0) return ;;
        *) echo -e "${R}Opcao invalida!${N}" ;;
    esac
    read -p "Enter para voltar..."
}

url_tool() {
    clear
    echo -e "${AZUL}=== CODIFICADOR DE URL ===${N}\n"
    echo -e "  ${AZUL}[1]${N} Codificar URL (Encode)"
    echo -e "  ${AZUL}[2]${N} Decodificar URL (Decode)"
    echo -e "  ${AZUL}[0]${N} Cancelar"
    read -p "  ➜ Opcao: " opcao

    if ! command -v python &>/dev/null; then
        echo -e "${R}[!] Python nao encontrado. Instale com: pkg install python${N}"
        read -p "Enter..." ; return
    fi

    case $opcao in
        1)
            read -p "Digite a URL ou texto: " url_txt
            ENCODE=$(python -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$url_txt")
            echo -e "\n${G}URL Codificada:${N}\n$ENCODE"
            ;;
        2)
            read -p "Digite a URL codificada: " url_enc
            DECODE=$(python -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1]))" "$url_enc")
            echo -e "\n${G}Texto Decodificado:${N}\n$DECODE"
            ;;
        0) return ;;
    esac
    read -p "Enter para voltar..."
}

validar_json() {
    clear
    echo -e "${AZUL}=== VALIDADOR E FORMATADOR JSON ===${N}\n"
    if ! command -v python &>/dev/null; then
        echo -e "${R}[!] Python nao encontrado. Instale com: pkg install python${N}"
        read -p "Enter..." ; return
    fi
    
    echo -e "${Y}Cole o JSON (uma linha so) e aperte Enter:${N}"
    read -p "➜ " json_txt
    
    # Tenta formatar o JSON com Python
    RESULTADO=$(echo "$json_txt" | python -m json.tool 2>&1)
    
    if [[ "$RESULTADO" == *"Expecting"* ]] || [[ "$RESULTADO" == *"error"* ]]; then
        echo -e "\n${R}[!] JSON INVALIDO!${N}"
        echo -e "  Erro: $RESULTADO"
    else
        echo -e "\n${G}[+] JSON VALIDO E FORMATADO:${N}"
        echo -e "${Y}$RESULTADO${N}"
    fi
    read -p "Enter para voltar..."
}

# ===== LOOP DO MODULO =====
while true; do
    clear
    echo -e "${AZUL}DEV TOOLS & SEGURANCA${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Gerador de Senhas Fortes"
    echo -e "      ${Y}-> Cria senhas aleatorias seguras${N}"
    echo -e "  ${AZUL}[2]${N} Hash SHA-256"
    echo -e "      ${Y}-> Gera a assinatura criptografica de um texto${N}"
    echo -e "  ${AZUL}[3]${N} Base64 (Encode/Decode)"
    echo -e "      ${Y}-> Codifica textos para transmissao${N}"
    echo -e "  ${AZUL}[4]${N} Codificador de URL"
    echo -e "      ${Y}-> Transforma textos em formato de link seguro${N}"
    echo -e "  ${AZUL}[5]${N} Validador e Formatador JSON"
    echo -e "      ${Y}-> Verifica se um codigo JSON esta correto${N}"
    echo -e "  ${AZUL}[0]${N} Voltar ao Menu Principal"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt

    case $opt in
        1) gerar_senha ;;
        2) gerar_hash ;;
        3) base64_tool ;;
        4) url_tool ;;
        5) validar_json ;;
        0) exit 0 ;;
        *) echo -e "${R}Opcao invalida!${N}"; sleep 1 ;;
    esac
done
