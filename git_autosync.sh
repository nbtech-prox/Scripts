#!/bin/bash

# =================================================================
# Script: Git Auto-Sync Daemon
# Descrição: Monitoriza internet e envia commits pendentes sozinho
# =================================================================

REPO_PATH="${1:-.}"
cd "$REPO_PATH" || exit

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuração Dinâmica
# Descobre o diretório onde o script está e usa a pasta "pai" como base de projetos
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BASE_DIR="$(dirname "$SCRIPT_DIR")" 

CHECK_HOST="1.1.1.1" 
CHECK_INTERVAL=300
LOG_FILE="/tmp/git_autosync.log"

echo "Monitorizando projetos em: $BASE_DIR" >> "$LOG_FILE"

while true; do
    # Só tenta sincronizar se houver internet
    if ping -c 1 "$CHECK_HOST" >/dev/null 2>&1; then
        
        # Procura por todas as pastas que contenham um diretório .git
        find "$BASE_DIR" -maxdepth 2 -name ".git" -type d | while read -r gitdir; do
            REPO_PATH=$(dirname "$gitdir")
            cd "$REPO_PATH" || continue
            
            # Verifica se há commits pendentes nesta pasta específica
            PENDING=$(git cherry -v origin/main 2>/dev/null)
            
            if [ -n "$PENDING" ]; then
                DATE=$(date '+%Y-%m-%d %H:%M:%S')
                REPO_NAME=$(basename "$REPO_PATH")
                echo "[$DATE] Sincronizando $REPO_NAME..." >> "$LOG_FILE"
                git push origin main >> "$LOG_FILE" 2>&1
            fi
        done
    fi
    sleep "$CHECK_INTERVAL"
done
