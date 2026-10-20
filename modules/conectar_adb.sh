#!/data/data/com.termux/files/usr/bin/bash
AZUL="\e[34m"; G="\e[32m"; Y="\e[33m"; R="\e[31m"; N="\e[0m"
clear
echo -e "${AZUL}=== CONECTAR ADB (MODO RÁPIDO) ===${N}\n"

if ! command -v adb &>/dev/null; then
    echo -e "${Y}Instalando android-tools...${N}"
    pkg install android-tools -y
fi

IP_LOCAL="127.0.0.1"
echo -e "${Y}Ative a 'Depuracao sem fio' nas Opcoes do Desenvolvedor.${N}\n"

echo -e "${AZUL}[1] Pareamento${N}"
read -p "  ➜ Porta de Pareamento (ex: 37000): " PORTA_PAREAMENTO
read -p "  ➜ Codigo de 6 digitos: " CODIGO

if [[ -z "$PORTA_PAREAMENTO" || -z "$CODIGO" ]]; then return; fi

echo -e "\n${Y}[*] Pareando...${N}"
adb pair "$IP_LOCAL:$PORTA_PAREAMENTO" "$CODIGO"

echo -e "\n${AZUL}[2] Conexao${N}"
echo -e "${Y}Copie a porta de conexao na tela do Android.${N}"
read -p "  ➜ Porta de Conexao (ex: 5555): " PORTA_CONEXAO

if [[ -z "$PORTA_CONEXAO" ]]; then return; fi

echo -e "\n${Y}[*] Conectando...${N}"
adb connect "$IP_LOCAL:$PORTA_CONEXAO"

if [ $? -eq 0 ]; then
    echo -e "\n${G}[+] DISPOSITIVO CONECTADO COM SUCESSO!${N}"
    echo -e "${Y}Volte ao menu do Bypass e escolha a opcao 2.${N}"
else
    echo -e "\n${R}[!] Falha na conexao. Verifique a porta e tente novamente.${N}"
fi
read -p "Enter para voltar..."
