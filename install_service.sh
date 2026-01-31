# 1. Copiar o script para uma pasta de sistema (torna-se um comando real)
echo "📦 Instalando o comando 'git-autosync' em /usr/local/bin..."
sudo cp "$(pwd)/git_autosync.sh" /usr/local/bin/git-autosync
sudo chmod +x /usr/local/bin/git-autosync

# 2. Caminho dos teus projetos (detecta onde estás agora, ou podes mudar)
PROJECTS_PATH="$(dirname "$(pwd)")"
SCRIPT_OWNER="$(whoami)"

echo "👤 Utilizador: $SCRIPT_OWNER"
echo "� Vigilância em: $PROJECTS_PATH"

# 3. Cria o serviço estático e limpo
sudo bash -c "cat <<EOF > /etc/systemd/system/git-autosync.service
[Unit]
Description=Vigilante de Projetos Git (Global)
After=network.target

[Service]
# Agora usamos o comando global com o caminho dos projetos como argumento
ExecStart=/usr/local/bin/git-autosync
Restart=always
User=$SCRIPT_OWNER

[Install]
WantedBy=multi-user.target
EOF"

# 4. Ativar
echo "🔄 A iniciar o serviço..."
sudo systemctl daemon-reload
sudo systemctl enable git-autosync.service
sudo systemctl restart git-autosync.service

echo "✅ INSTALAÇÃO CONCLUÍDA!"
echo "O script agora é um comando de sistema. Podes vê-lo em /usr/local/bin/git-autosync"
