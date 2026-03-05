# �️ NBTech: Repositório de Scripts e Automação

Uma coleção centralizada de scripts utilitários para diversos fins (Bash, Python, Automação, etc.). Este repositório serve como base para as minhas ferramentas de dia a dia e automatismos de sistema.

---

## 📂 Organização do Repositório

### 🔧 Gestão e Manutenção
Estes scripts ajudam a manter o sistema saudável e o Git sincronizado.

| Ficheiro | Função |
| :--- | :--- |
| `ops.sh` | **Centro de Operações**. Diagnóstico rápido de RAM, Disco, CPU e limpeza. |
| `setup_multi_git_v3.sh` | Configura o projeto para enviar commits para GitHub, GitLab e Codeberg simultaneamente. |
| `git_autosync.sh` | Monitor que faz o push automático dos commits pendentes. |
| `install_service.sh` | Instalador do serviço de auto-sync (Daemon). |

### � Outros Scripts
*(Novos scripts utilitários serão agregados aqui)*
- [ ] Script de Backup (Em breve)
- [ ] Limpeza de Sistema (Em breve)

---

## 🛠️ Como Utilizar as Ferramentas

### Sincronização Automática entre GitHub, GitLab e Codeberg
Se deseja usar os automatismos de Git incluídos neste repositório:

1.  **Configurar Remotos Triplos**:
    ```bash
    ./setup_multi_git_v3.sh /caminho/do/projeto
    ```
2.  **Ativar Sincronização em Segundo Plano (Opcional)**:
    ```bash
    ./install_service.sh
    ```

### Workflow com o Vigilante Git (Daemon)
1.  **Trabalho**: Faça as suas alterações e use `git commit`. 
2.  **Sincronização**: O serviço `git-autosync` envia os commits sozinho assim que houver rede.
3.  **Manual**: Pode sempre usar `git push origin` para enviar imediatamente para os remotos configurados.

---

## 🔍 Monitorização do Sistema
Se tiver o serviço de sincronização instalado:
- **Logs**: `tail -f /tmp/git_autosync.log`
- **Status**: `systemctl status git-autosync.service`

---

## 📄 Licença

Este projeto está licenciado sob a **GNU General Public License v3.0 (GPL-3.0)**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---
*Mantido por **NBTech***
