#!/bin/bash

# ===============================
# Script definitivo: GitHub + GitLab
# Identidades fixas, SSH interativo
# ===============================

# Caminho do projeto
REPO_PATH="$1"
if [ -z "$REPO_PATH" ]; then
    echo "Uso: $0 /caminho/para/projeto"
    exit 1
fi

cd "$REPO_PATH" || exit

# ===============================
# Inicializa repositório se necessário
# ===============================
if [ ! -d ".git" ]; then
    echo "Repositório Git não encontrado. Inicializando..."
    git init -b main
else
    echo "Repositório Git encontrado."
fi

# ===============================
# Identidades fixas
# ===============================
# GitHub global
GITHUB_USER="NBTech"
GITHUB_EMAIL="nbtech.prox@gmail.com"
git config --global user.name "$GITHUB_USER"
git config --global user.email "$GITHUB_EMAIL"

# GitLab local
GITLAB_USER="Nuno Batista"
GITLAB_EMAIL="nbtech.git@gmail.com"
git config --local user.name "$GITLAB_USER"
git config --local user.email "$GITLAB_EMAIL"

echo "Identidades configuradas: GitHub (global), GitLab (local)."

# ===============================
# Perguntar pelos links SSH
# ===============================
read -p "Digite o link SSH do repositório GitHub: " GITHUB_URL
read -p "Digite o link SSH do repositório GitLab: " GITLAB_URL

# ===============================
# Configura remotos
# ===============================
# GitHub
if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "$GITHUB_URL"
else
    git remote add origin "$GITHUB_URL"
fi

# GitLab
if git remote get-url gitlab >/dev/null 2>&1; then
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
# Mensagem final
# ===============================
echo "Setup completo!"
echo "Agora você pode:"
echo "1. git add ."
echo "2. git commit -m 'sua mensagem'"
echo "3. git pushall   # envia para GitHub e GitLab"
echo "Ou enviar individualmente:"
echo "   git push origin main   # GitHub"
echo "   git push gitlab main   # GitLab"
