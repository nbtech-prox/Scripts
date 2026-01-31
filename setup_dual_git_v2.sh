#!/bin/bash

# =================================================================
# Script: Setup Dual Git Pro (GitHub + GitLab)
# Versão: 2.0
# Descrição: Configuração automática de identidades e remotos duplos
# =================================================================

# Cores para uma interface "premium" no terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}   SINCRO-GIT: GITHUB + GITLAB v2.0    ${NC}"
echo -e "${BLUE}=======================================${NC}"

# 1. Validação do Caminho (Usa diretório atual se não passado como argumento)
REPO_PATH="${1:-.}"
if [ ! -d "$REPO_PATH" ]; then
    echo -e "${RED}✘ Erro: O diretório '$REPO_PATH' não existe.${NC}"
    exit 1
fi
cd "$REPO_PATH" || exit

# 2. Inicialização Inteligente
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚡ Inicializando novo repositório Git...${NC}"
    git init -b main
else
    echo -e "${GREEN}✔ Repositório Git existente detectado.${NC}"
fi

# 3. Configuração de Identidades e Comportamento
echo -e "\n${CYAN}⚙ Configurando identidades e automatismos...${NC}"

# GitHub Global
git config --global user.name "NBTech"
git config --global user.email "nbtech.prox@gmail.com"

# GitLab Local
git config --local user.name "Nuno Batista"
git config --local user.email "nbtech.git@gmail.com"

# Automatismo: Evita o erro de "no upstream branch"
git config --global push.autoSetupRemote true

echo -e "  - GitHub (Global): ${GREEN}NBTech${NC}"
echo -e "  - GitLab (Local):  ${GREEN}Nuno Batista${NC}"
echo -e "  - Auto-Upstream:   ${GREEN}Ativado${NC}"

# 4. Detecção de URLs Atuais
CURRENT_GH=$(git remote get-url github 2>/dev/null || git remote get-url origin 2>/dev/null)
CURRENT_GL=$(git remote get-url gitlab 2>/dev/null)

echo -e "\n${CYAN}🔗 Configuração de Remotos:${NC}"
echo -e "${YELLOW}(Pressione ENTER para manter a URL atual)${NC}"

# Função para validar se a URL é SSH (formato básico)
validate_ssh() {
    if [[ ! $1 =~ ^git@.* ]]; then
        echo -e "${RED}⚠ Aviso: A URL não parece estar no formato SSH (git@...).${NC}"
        echo -e "${RED}Isso pode causar problemas com autenticação automática.${NC}"
    fi
}

# Pergunta URLs
read -p "➔ GitHub SSH URL [${CURRENT_GH}]: " GITHUB_URL
GITHUB_URL="${GITHUB_URL:-$CURRENT_GH}"
[ -n "$GITHUB_URL" ] && validate_ssh "$GITHUB_URL"

read -p "➔ GitLab SSH URL [${CURRENT_GL}]: " GITLAB_URL
GITLAB_URL="${GITLAB_URL:-$CURRENT_GL}"
[ -n "$GITLAB_URL" ] && validate_ssh "$GITLAB_URL"

if [ -z "$GITHUB_URL" ] || [ -z "$GITLAB_URL" ]; then
    echo -e "${RED}✘ Erro: Ambas as URLs são necessárias para o setup dual.${NC}"
    exit 1
fi

# 5. Configuração dos Remotos Individuais e Mestre
echo -e "\n${CYAN}🚀 Aplicando configurações de rede...${NC}"

setup_remote() {
    local name=$1
    local url=$2
    git remote remove "$name" >/dev/null 2>&1
    git remote add "$name" "$url"
}

# Remotos Individuais
setup_remote "github" "$GITHUB_URL"
setup_remote "gitlab" "$GITLAB_URL"

# Remoto Mestre (Origin) com Multi-Push
setup_remote "origin" "$GITHUB_URL"
git remote set-url --push --add origin "$GITHUB_URL"
git remote set-url --push --add origin "$GITLAB_URL"

# 6. Finalização
echo -e "\n${GREEN}=======================================${NC}"
echo -e "${GREEN}   ✔ SETUP CONCLUÍDO COM SUCESSO!      ${NC}"
echo -e "${GREEN}=======================================${NC}"
echo -e "Comandos de Push Disponíveis:"
echo -e "1. ${YELLOW}git push origin${NC}  -> 🚄 Envia para ambos (GitHub + GitLab)"
echo -e "2. ${YELLOW}git push github${NC}  -> 🐙 Envia apenas para o GitHub"
echo -e "3. ${YELLOW}git push gitlab${NC}  -> 🦊 Envia apenas para o GitLab"
echo -e "=======================================\n"
