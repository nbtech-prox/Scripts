#!/bin/bash

# ===============================
# Script tudo em um para GitHub + GitLab
# ===============================

# Caminho do projeto (argumento)
REPO_PATH="$1"
if [ -z "$REPO_PATH" ]; then
    echo "Uso: $0 /caminho/para/projeto"
    exit 1
fi

cd "$REPO_PATH" || exit

# ===============================
# Verifica se já existe um repositório Git
# ===============================
if [ ! -d ".git" ]; then
    echo "Repositório Git não encontrado. Inicializando..."
    git init -b main
else
    echo "Repositório Git encontrado."
fi

# ===============================
# Perguntar pelo link SSH do GitHub
# ===============================
read -p "Digite o link SSH do repositório GitHub: " GITHUB_URL
if [ -z "$GITHUB_URL" ]; then
    echo "Erro: é necessário fornecer o link do GitHub."
    exit 1
fi

# ===============================
# Perguntar pelo link SSH do GitLab
# ===============================
read -p "Digite o link SSH do repositório GitLab: " GITLAB_URL
if [ -z "$GITLAB_URL" ]; then
    echo "Erro: é necessário fornecer o link do GitLab."
    exit 1
fi

# ===============================
# Configura identidade global para GitHub (se ainda não existir)
# ===============================
if ! git config --global user.name >/dev/null; then
    read -p "Digite seu nome para GitHub (global): " GITHUB_USER
    read -p "Digite seu email para GitHub (global): " GITHUB_EMAIL
    git config --global user.name "$GITHUB_USER"
    git config --global user.email "$GITHUB_EMAIL"
    echo "Configuração global GitHub aplicada."
fi

# ===============================
# Configura identidade local para GitLab
# ===============================
read -p "Digite seu nome para GitLab (local): " GITLAB_USER
read -p "Digite seu email para GitLab (local): " GITLAB_EMAIL
git config --local user.name "$GITLAB_USER"
git config --local user.email "$GITLAB_EMAIL"
echo "Configuração local GitLab aplicada."

# ===============================
# Configura remotos
# ===============================
# GitHub
if git remote get-url origin >/dev/null 2>&1; then
    echo "Remoto origin (GitHub) já existe. Atualizando URL..."
    git remote set-url origin "$GITHUB_URL"
else
    git remote add origin "$GITHUB_URL"
fi

# GitLab
if git remote get-url gitlab >/dev/null 2>&1; then
    echo "Remoto gitlab já existe. Atualizando URL..."
    git remote set-url gitlab "$GITLAB_URL"
else
    git remote add gitlab "$GITLAB_URL"
fi

# ===============================
# Detecta ou cria branch principal
# ===============================
MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
[ -z "$MAIN_BRANCH" ] && MAIN_BRANCH="main"
git branch -M $MAIN_BRANCH
echo "Branch principal: $MAIN_BRANCH"

# ===============================
# Criar alias pushall
# ===============================
git config --local alias.pushall "!git push origin $MAIN_BRANCH && git push gitlab $MAIN_BRANCH"
echo "Alias 'pushall' criado: envia para GitHub e GitLab simultaneamente."

# ===============================
# Pronto para push inicial (opcional)
# ===============================
echo "Setup completo! Agora basta:"
echo "1. git add ."
echo "2. git commit -m 'mensagem'"
echo "3. git pushall   # envia para GitHub e GitLab simultaneamente"
echo "Você também pode usar 'git push origin main' ou 'git push gitlab main' individualmente."
