# Meus Scripts Customizados

Este repositório é uma coleção de scripts utilitários desenvolvidos para facilitar tarefas do dia a dia, automação de sistemas e configurações de ambiente.

## 🚀 Objetivo

O objetivo deste projeto é agregar diversos scripts (Bash, Python, etc.) em um único local, permitindo fácil acesso e versionamento tanto no GitHub quanto no GitLab.

## 📂 Estrutura do Repositório

Atualmente, o repositório contém:

- `setup_git.sh`: Script para configuração básica do Git.
- `setup_dual_git_v2.sh`: Script avançado para configurar múltiplos remotos (GitHub e GitLab).
- `git_autosync.sh`: Monitor que sincroniza commits automaticamente ao detectar internet.
- `install_service.sh`: Instalador para configurar o auto-sync como serviço de sistema (daemon).

## 🛠️ Como usar

### 1. Configuração Automática (Dual Git)

Para configurar um novo projeto:

```bash
chmod +x setup_dual_git_v2.sh
./setup_dual_git_v2.sh /caminho/do/projeto
```

### 2. Sincronização Automática (Modo Offline)

O **Vigilante Git** detecta quando você volta a estar online e faz o push dos seus commits pendentes sozinho.

**Instalação:**
```bash
chmod +x install_service.sh
./install_service.sh
```

**Comandos Úteis:**
- Monitorar logs: `tail -f /tmp/git_autosync.log`
- Ver estado do serviço: `systemctl status git-autosync.service`

### Fluxo de Trabalho

1. **Automático**: Faça seus `git commit`. O serviço cuida do resto assim que houver rede.
2. **`git push origin`**: Envia manualmente para ambos ao mesmo tempo.
3. **`git push github`**: Envia individualmente.
4. **`git push gitlab`**: Envia individualmente.

## 📄 Licença

Este projeto está licenciado sob a **GNU General Public License v3.0 (GPL-3.0)**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---
*Criado e mantido por [Seu Nome/Usuário]*
