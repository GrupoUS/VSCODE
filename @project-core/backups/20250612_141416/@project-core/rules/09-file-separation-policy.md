# 📁 POLÍTICA DE SEPARAÇÃO DE ARQUIVOS - VIBECODE SYSTEM V4.0

**Data de Implementação**: 2025-01-27  
**Status**: ✅ ATIVO  
**Aplicação**: Obrigatória para todos os scripts e workflows

---

## 🎯 OBJETIVO

Estabelecer separação permanente entre arquivos operacionais (para GitHub) e arquivos temporários (logs/backups) para otimizar uploads e manter o repositório limpo.

---

## 📋 CLASSIFICAÇÃO DE ARQUIVOS

### **✅ ARQUIVOS OPERACIONAIS (Permanecem no Projeto)**

**Diretórios Essenciais:**
- `@project-core/automation/helpers/` - Módulos da hiper-otimização V4
- `@project-core/automation/tasks/` - Scripts refatorados + archive_manager.py
- `@project-core/memory/` - Sistema de memória e aprendizado
- `@project-core/configs/` - Configurações do sistema
- `@project-core/rules/` - Regras e políticas
- `@project-core/docs/` - Documentação técnica
- `.github/workflows/` - CI/CD

**Arquivos de Configuração:**
- `requirements.txt`
- `README.md`
- Arquivos de configuração de desenvolvimento

**Logs Essenciais (Apenas Recentes):**
- Logs dos scripts da hiper-otimização (últimos 7 dias)
- Logs de sistema críticos

### **🔄 ARQUIVOS TEMPORÁRIOS (Movidos para Backup Externo)**

**Relatórios Temporários:**
- Relatórios da hiper-otimização (após conclusão)
- Relatórios de backup/monitoring com timestamps
- Relatórios de teste antigos (manter apenas o mais recente)

**Logs Temporários:**
- Logs de backup/monitoring
- Logs de validação com timestamps
- Logs de sistema antigos (>7 dias)

**Backups:**
- Diretórios de backup completos
- Arquivos de backup com timestamps
- Snapshots de sistema

---

## 🎯 DESTINO OBRIGATÓRIO

**Pasta de Backup Externa:**
```
C:\Users\Admin\OneDrive\Documentos\VSCODE-BACKUP\
├── reports/                 # Relatórios arquivados
├── logs/                    # Logs temporários
├── backups/                 # Backups de sistema
└── automation_backup/       # Backups de automação
```

---

## 🔧 IMPLEMENTAÇÃO NOS SCRIPTS

### **Scripts da Hiper-Otimização V4**

**archive_manager.py:**
```python
# Configuração de destino externo
EXTERNAL_BACKUP_PATH = "C:/Users/Admin/OneDrive/Documentos/VSCODE-BACKUP"

def archive_old_logs(self, days_old: int = 7):
    # Arquivar logs antigos diretamente para pasta externa
    external_archive = Path(EXTERNAL_BACKUP_PATH) / "logs"
    # ... implementação
```

**maintenance.py:**
```python
# Configuração de backup externo
def create_backup(self, source_path: str = None):
    # Criar backups diretamente na pasta externa
    external_backup = Path("C:/Users/Admin/OneDrive/Documentos/VSCODE-BACKUP/backups")
    # ... implementação
```

**Todos os Scripts de Logging:**
```python
# Configuração de logs
def setup_logging():
    # Logs recentes no projeto (7 dias)
    # Logs antigos movidos automaticamente para pasta externa
```

---

## 📊 CRITÉRIOS DE RETENÇÃO

### **No Projeto (GitHub)**
- **Logs**: Últimos 7 dias apenas
- **Relatórios**: Apenas o mais recente de cada tipo
- **Backups**: Nenhum (todos externos)
- **Arquivos Temporários**: Nenhum

### **Backup Externo**
- **Logs**: Retenção de 30 dias
- **Relatórios**: Retenção de 90 dias
- **Backups**: Retenção de 180 dias
- **Arquivos da Hiper-Otimização**: Permanente

---

## 🚀 AUTOMAÇÃO

### **Scripts Atualizados**

**archive_manager.py:**
- Arquivamento automático para pasta externa
- Limpeza automática de logs antigos no projeto
- Manutenção da política de retenção

**maintenance.py:**
- Backups criados diretamente na pasta externa
- Monitoramento de espaço no projeto
- Alertas de violação da política

**Todos os Scripts de Automação:**
- Logs direcionados para pasta externa após 7 dias
- Relatórios temporários movidos automaticamente
- Validação da política em cada execução

---

## ✅ VALIDAÇÃO

### **Verificações Automáticas**
1. **Tamanho do Projeto**: Máximo 50MB para GitHub
2. **Logs Antigos**: Nenhum log >7 dias no projeto
3. **Relatórios Temporários**: Máximo 1 de cada tipo
4. **Backups**: Nenhum backup no projeto principal

### **Comandos de Validação**
```bash
# Verificar tamanho do projeto
python @project-core/automation/tasks/monitor.py --type structure

# Validar política de arquivos
python @project-core/automation/tasks/archive_manager.py --validate-policy

# Limpeza automática
python @project-core/automation/tasks/archive_manager.py --cleanup-old-files
```

---

## 🎯 BENEFÍCIOS

### **Para GitHub**
- ✅ Repositório limpo e otimizado
- ✅ Uploads rápidos (apenas arquivos essenciais)
- ✅ Histórico focado em código operacional
- ✅ Redução de 70-80% no tamanho

### **Para Desenvolvimento**
- ✅ Separação clara entre operacional e temporário
- ✅ Backup seguro de arquivos históricos
- ✅ Performance melhorada
- ✅ Organização automática

### **Para Manutenção**
- ✅ Política automatizada
- ✅ Retenção inteligente
- ✅ Limpeza automática
- ✅ Monitoramento contínuo

---

## 🔒 COMPLIANCE

### **Obrigatório para Todos os Scripts**
- Implementar destino externo para arquivos temporários
- Respeitar critérios de retenção
- Validar política em cada execução
- Documentar violações no log de sistema

### **Validação Contínua**
- Execução automática da validação
- Alertas de violação da política
- Correção automática quando possível
- Relatório de compliance semanal

---

**🚀 POLÍTICA IMPLEMENTADA E ATIVA - VIBECODE SYSTEM V4.0 🚀**

*Implementada em 2025-01-27 após conclusão da Hiper-Otimização V4*
