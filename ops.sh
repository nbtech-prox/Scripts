#!/bin/bash

# =================================================================
# Script: ops.sh (Centro de Operações NBTech)
# Descrição: Diagnóstico rápido e manutenção do sistema
# =================================================================

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}      NBTECH OPERATIONS CENTER         ${NC}"
echo -e "${BLUE}=======================================${NC}"

# 1. Informação de Memória
echo -e "${CYAN}[🧠 Memória RAM]${NC}"
free -h | grep -E "total|Mem" | awk '{print "  Total: "$2 " | Usado: "$3 " | Livre: "$4}'

# 2. Informação de Disco (Partição Raiz)
echo -e "\n${CYAN}[💽 Armazenamento]${NC}"
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
DISK_INFO=$(df -h / | tail -1 | awk '{print $2" Total | "$3" Usado | "$4" Disponível ("$5")"}')

if [ "$DISK_USAGE" -gt 85 ]; then
    echo -e "  ${RED}⚠ AVISO: Disco quase cheio!${NC}"
    echo -e "  $DISK_INFO"
else
    echo -e "  $DISK_INFO"
fi

# 3. Carga do Sistema (CPU)
echo -e "\n${CYAN}[⚡ Processador]${NC}"
UPTIME=$(uptime | awk -F'load average:' '{ print $2 }')
echo -e "  Carga (1, 5, 15 min):$UPTIME"

# 4. Top 3 Processos (por memória)
echo -e "\n${CYAN}[🔝 Top Processos (Memória)]${NC}"
ps aux --sort=-%mem | head -4 | tail -3 | awk '{print "  " $11 " (" $4 "%)"}'

echo -e "${BLUE}=======================================${NC}"
echo -e "O que desejas fazer?"
echo -e "  ${YELLOW}1)${NC} Limpeza Rápida (Lixeira, Cache, Logs)"
echo -e "  ${YELLOW}2)${NC} Procurar Atualizações do Sistema"
echo -e "  ${YELLOW}q)${NC} Sair"
echo -e "${BLUE}=======================================${NC}"

read -p "➔ Opção: " OPT

case $OPT in
    1)
        echo -e "\n${YELLOW}🧹 Iniciando limpeza...${NC}"
        # Limpar lixeira
        rm -rf ~/.local/share/Trash/* 2>/dev/null
        # Limpar cache do APT (se for Debian/Ubuntu)
        sudo apt-get clean 2>/dev/null || sudo dnf clean all 2>/dev/null
        # Limpar logs antigos do journal
        sudo journalctl --vacuum-time=3d 2>/dev/null
        echo -e "${GREEN}✔ Limpeza concluída!${NC}"
        ;;
    2)
        echo -e "\n${YELLOW}🔄 Verificando atualizações...${NC}"
        sudo apt-get update 2>/dev/null || sudo dnf check-update 2>/dev/null
        echo -e "${GREEN}✔ Verificação terminada!${NC}"
        ;;
    q)
        echo "Até logo!"
        exit 0
        ;;
    *)
        echo "Opção inválida."
        ;;
esac
