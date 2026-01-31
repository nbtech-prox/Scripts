# Meus Scripts Customizados

Este repositório é uma coleção de scripts utilitários desenvolvidos para facilitar tarefas do dia a dia, automação de sistemas e configurações de ambiente.

## 🚀 Objetivo

O objetivo deste projeto é agregar diversos scripts (Bash, Python, etc.) em um único local, permitindo fácil acesso e versionamento tanto no GitHub quanto no GitLab.

## 📂 Estrutura do Repositório

Atualmente, o repositório contém:

- `setup_git.sh`: Script para configuração básica do Git.
- `setup_dual_git_v2.sh`: Script avançado para configurar múltiplos remotos (GitHub e GitLab) com push unificado em um único comando.

## 🛠️ Como usar

### Configuração Automática (Dual Git)

Para configurar um novo projeto ou um projeto existente para sincronizar com GitHub e GitLab simultaneamente:

```bash
chmod +x setup_dual_git_v2.sh
./setup_dual_git_v2.sh /caminho/do/meu/projeto
```

### Fluxo de Trabalho

Após a configuração, você terá os seguintes comandos de envio:

1. **`git push origin`**: Envia o código para **GitHub e GitLab** ao mesmo tempo. (Recomendado)
2. **`git push github`**: Envia apenas para o GitHub.
3. **`git push gitlab`**: Envia apenas para o GitLab.

## 📄 Licença

Este projeto está licenciado sob a **GNU General Public License v3.0 (GPL-3.0)**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---
*Criado e mantido por [Seu Nome/Usuário]*
