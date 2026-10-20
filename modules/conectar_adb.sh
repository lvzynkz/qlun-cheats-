#!/data/data/com.termux/files/usr/bin/bash
AZUL="\e[34m"; G="\e[32m"; Y="\e[33m"; R="\e[31m"; N="\e[0m"
clear
echo -e "${AZUL}=== CONECTAR ADB (MODO RÁPIDO) ===${N}\n"
if ! command -v adb &>/dev/null; then pkg install android-tools -y; fi
IP_LOCAL="127.0.0.1"
read -p "  ➜ Porta de Pareamento (ex: 37000): " PORTA_PAREAMENTO
read -p "  ➜ Codigo de 6 digitos: " CODIGO
if [[ -z "$PORTA_PAREAMENTO" || -z "$CODIGO" ]]; then return; fi
adb pair "$IP_LOCAL:$PORTA_PAREAMENTO" "$CODIGO"
read -p "  ➜ Porta de Conexao (ex: 5555): " PORTA_CONEXAO
if [[ -z "$PORTA_CONEXAO" ]]; then return; fi
adb connect "$IP_LOCAL:$PORTA_CONEXAO"
if [ $? -eq 0 ]; then echo -e "\n${G}[+] CONECTADO COM SUCESSO!${N}"; else echo -e "\n${R}[!] Falha.${N}"; fi
read -p "Enter para voltar..."
