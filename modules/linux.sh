#!/data/data/com.termux/files/usr/bin/bash

# ===== CORES =====
AZUL="\e[34m"
G="\e[32m"
Y="\e[33m"
R="\e[31m"
N="\e[0m"

# ===== FUNÇÕES =====

info_sistema() {
    clear
    echo -e "${AZUL}=== INFORMACOES DO SISTEMA ===${N}\n"
    ANDROID=$(getprop ro.build.version.release 2>/dev/null)
    MODELO=$(getprop ro.product.model 2>/dev/null)
    ARCH=$(uname -m)
    KERNEL=$(uname -r)
    
    echo -e "${Y}Dispositivo:${N} $MODELO"
    echo -e "${Y}Android:${N}     $ANDROID"
    echo -e "${Y}Kernel:${N}      $KERNEL"
    echo -e "${Y}Arquitetura:${N} $ARCH"
    
    echo -e "\n${Y}Memoria RAM:${N}"
    free -h | awk '/Mem:/ {print "  Usada: "$3" | Livre: "$4" | Total: "$2}'
    
    echo -e "\n${Y}Armazenamento (/data):${N}"
    df -h /data | tail -1 | awk '{print "  Usado: "$3" | Livre: "$4" | Total: "$2}'
    
    read -p "Enter para voltar..."
}

monitor_processos() {
    clear
    echo -e "${AZUL}=== MONITOR DE PROCESSOS ===${N}\n"
    
    if command -v htop &>/dev/null; then
        echo -e "${Y}Abrindo htop (interativo). Aperte 'q' para sair.${N}"
        sleep 2
        htop
    else
        echo -e "${Y}Mostrando TOP 10 processos (CPU):${N}"
        echo -e "${R}[Dica] Instale o 'htop' na opcao 3 para um visual melhor!${N}\n"
        top -b -n 1 | head -n 15
        read -p "Enter para voltar..."
    fi
}

instalar_pacote() {
    clear
    echo -e "${AZUL}=== INSTALADOR DE PACOTES ===${N}\n"
    echo -e "${Y}Espaco livre em disco:${N} $(df -h /data | tail -1 | awk '{print $4}')"
    
    echo -e "\n${Y}Escolha um pacote para instalar:${N}"
    echo -e "  ${AZUL}[1]${N} nmap (Scanner de rede)"
    echo -e "  ${AZUL}[2]${N} python (Linguagem de programacao)"
    echo -e "  ${AZUL}[3]${N} htop (Monitor de processos visual)"
    echo -e "  ${AZUL}[4]${N} neofetch (Info do sistema estilizada)"
    echo -e "  ${AZUL}[5]${N} git (Controle de versao)"
    echo -e "  ${AZUL}[6]${N} Outro pacote (digitar nome)"
    echo -e "  ${AZUL}[0]${N} Cancelar"
    read -p "  ➜ Opcao: " pkg_opt

    case $pkg_opt in
        1) PKG="nmap" ;;
        2) PKG="python" ;;
        3) PKG="htop" ;;
        4) PKG="neofetch" ;;
        5) PKG="git" ;;
        6) read -p "Digite o nome do pacote: " PKG ;;
        *) return ;;
    esac

    if [[ -z "$PKG" ]]; then return; fi
    
    echo -e "\n${Y}Instalando '$PKG'...${N}"
    if pkg install "$PKG" -y; then
        echo -e "\n${G}[+] Pacote '$PKG' instalado com sucesso!${N}"
    else
        echo -e "\n${R}[!] Falha ao instalar. Verifique o nome ou a internet.${N}"
    fi
    read -p "Enter para voltar..."
}

diagnostico_deps() {
    clear
    echo -e "${AZUL}=== DIAGNOSTICO DE DEPENDENCIAS ===${N}\n"
    
    FALTANDO=0
    for cmd in curl git python nmap proot-distro; do
        if command -v "$cmd" &>/dev/null; then
            echo -e "  ${G}[OK]${N} $cmd instalado."
        else
            echo -e "  ${R}[X] ${N} $cmd NAO encontrado."
            FALTANDO=1
        fi
    done

    if [ "$FALTANDO" -eq 1 ]; then
        echo -e "\n${Y}Deseja instalar todos os pacotes que faltam de uma vez? (s/n)${N}"
        read -p "➜ " auto_inst
        if [[ "$auto_inst" == "s" || "$auto_inst" == "S" ]]; then
            pkg update -y
            for cmd in curl git python nmap proot-distro; do
                if ! command -v "$cmd" &>/dev/null; then
                    pkg install "$cmd" -y
                fi
            done
            echo -e "\n${G}[+] Dependencias corrigidas!${N}"
        fi
    else
        echo -e "\n${G}[+] Todas as dependencias estao instaladas!${N}"
    fi
    read -p "Enter para voltar..."
}

gerenciar_linux() {
    clear
    echo -e "${AZUL}=== GERENCIADOR LINUX (PROOT) ===${N}\n"
    
    if ! command -v proot-distro &>/dev/null; then
        echo -e "${Y}O 'proot-distro' nao esta instalado. Instalando...${N}"
        pkg install proot-distro -y
    fi

    echo -e "${Y}Distros instaladas no seu celular:${N}"
    INSTALADAS=$(proot-distro list | grep "Installed" | awk '{print $1}')
    
    if [ -z "$INSTALADAS" ]; then
        echo -e "  ${R}Nenhuma distro instalada.${N}"
    else
        echo -e "${G}$INSTALADAS${N}"
    fi

    echo -e "\n  ${AZUL}[1]${N} Instalar nova distro (Alpine/Debian)"
    echo -e "  ${AZUL}[2]${N} Entrar em uma distro instalada"
    echo -e "  ${AZUL}[0]${N} Cancelar"
    read -p "  ➜ Opcao: " linux_opt

    case $linux_opt in
        1)
            echo -e "\n${Y}[1]${N} Alpine (~3MB) | ${Y}[2]${N} Debian (~80MB)"
            read -p "Escolha: " distro_inst
            if [[ "$distro_inst" == "1" ]]; then DISTRO="alpine"; 
            elif [[ "$distro_inst" == "2" ]]; then DISTRO="debian"; 
            else return; fi
            
            echo -e "\n${Y}Instalando $DISTRO...${N}"
            proot-distro install "$DISTRO"
            read -p "Enter..."
            ;;
        2)
            read -p "Digite o nome exato da distro (ex: alpine): " login_distro
            if [[ -n "$login_distro" ]]; then
                echo -e "${Y}Entrando no $login_distro (digite 'exit' para sair)...${N}"
                sleep 1.5
                proot-distro login "$login_distro"
            fi
            ;;
        *) return ;;
    esac
}

# ===== LOOP DO MODULO =====
while true; do
    clear
    echo -e "${AZUL}LINUX & TERMINAL${N}"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    echo -e "  ${AZUL}[1]${N} Informacoes do Sistema"
    echo -e "      ${Y}-> Modelo, Android, RAM e Disco${N}"
    echo -e "  ${AZUL}[2]${N} Monitor de Processos"
    echo -e "      ${Y}-> Ver o que esta consumindo o celular${N}"
    echo -e "  ${AZUL}[3]${N} Instalador de Pacotes"
    echo -e "      ${Y}-> Instalar ferramentas uteis rapidamente${N}"
    echo -e "  ${AZUL}[4]${N} Diagnostico de Dependencias"
    echo -e "      ${Y}-> Verificar e corrigir o que falta${N}"
    echo -e "  ${AZUL}[5]${N} Gerenciador Linux (Proot)"
    echo -e "      ${Y}-> Instalar e entrar em distros Linux${N}"
    echo -e "  ${AZUL}[0]${N} Voltar ao Menu Principal"
    echo -e "  ${AZUL}─────────────────────────────────────────${N}"
    read -p "  ➜ Opcao: " opt

    case $opt in
        1) info_sistema ;;
        2) monitor_processos ;;
        3) instalar_pacote ;;
        4) diagnostico_deps ;;
        5) gerenciar_linux ;;
        0) exit 0 ;;
        *) echo -e "${R}Opcao invalida!${N}"; sleep 1 ;;
    esac
done
