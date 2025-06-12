# Project Overview - GRUPO US SaaS

## Projeto: Sistema de Gestão para Clínicas de Estética

### Visão Geral
Plataforma SaaS completa para gestão de clínicas de estética, incluindo:
- Agendamento de consultas
- Gestão de pacientes
- Controle financeiro
- Gestão de estoque
- Relatórios e analytics

### Status Atual
- **Fase**: MVP em desenvolvimento
- **Progresso**: 40% completo
- **Próximo Marco**: Sistema de agendamento funcional

### Stakeholders
- **CEO**: [Nome]
- **Tech Lead**: [Nome]
- **Clientes Beta**: 3 clínicas parceiras

### Requisitos Principais
1. Multi-tenant com isolamento por clínica
2. Interface mobile-first
3. Integração com WhatsApp
4. Dashboard com métricas em tempo real
5. Sistema de notificações

### Decisões Técnicas Tomadas
1. **Arquitetura**: Multi-tenant com schema compartilhado
2. **Autenticação**: Supabase Auth com RLS
3. **Pagamentos**: Stripe (a implementar)
4. **Hospedagem**: Vercel + Supabase
5. **Monitoramento**: Vercel Analytics + Sentry

### Riscos Identificados
1. Complexidade do sistema de agendamento
2. Performance com múltiplas clínicas
3. Conformidade LGPD
4. Integração com sistemas legados

### Métricas de Sucesso
- Time to market: 3 meses
- Performance: <3s carregamento inicial
- Uptime: 99.9%
- Satisfação: NPS > 8

## INSTRUÇÕES DE USO
Execute os comandos de criação de diretórios no terminal
Crie cada arquivo MDC com o conteúdo fornecido
No Cursor, os arquivos serão automaticamente reconhecidos
Teste o sistema pedindo ao Cursor: "Consulte a memória do projeto e me diga qual é a stack tecnológica"

## COMANDOS ADICIONAIS PARA MANUTENÇÃO
```bash
# Atualizar memória após mudanças significativas
echo "## Update $(date +%Y-%m-%d)" >> memory-bank/05-progress-log.md

# Backup da memória
tar -czf memory-backup-$(date +%Y%m%d).tar.gz .cursor/rules memory-bank

# Verificar integridade
find .cursor/rules -name "*.mdc" -exec echo "✓ {}" \;
```

## INTEGRAÇÃO COM CLINE
Para máxima eficiência, adicione estas regras ao .clinerules:

```markdown
# .clinerules/memory-integration.md

## INTEGRAÇÃO COM SISTEMA DE MEMÓRIA

Sempre que iniciar uma nova sessão:
1. Ler todos os arquivos em .cursor/rules/
2. Consultar memory-bank/ para contexto do projeto
3. Verificar docs/ para decisões recentes

Ao finalizar tarefas:
1. Atualizar self.mdc com erros encontrados
2. Adicionar novas APIs em apis.mdc
3. Documentar mudanças no schema em database-schema.mdc
4. Registrar progresso em memory-bank/05-progress-log.md

Usar @memory para referenciar sistema de memória completo.
Este sistema de memória garantirá que o Cursor mantenha contexto completo entre sessões, aprenda com erros e siga os padrões estabelecidos pelo GRUPO US. 🚀 