# .clinerules/05-taskmaster-sequential.md

## REGRA: USO INTELIGENTE DO TASKMASTER + SEQUENTIAL THINKING

### QUANDO USAR SEQUENTIAL THINKING AUTOMATICAMENTE:
1. Tasks com mais de 5 subtasks
2. Descrições contendo: "arquitetar", "planejar", "analisar", "complexo"
3. Confidence score < 7
4. Primeira vez implementando uma feature
5. Mudanças que afetam múltiplos componentes

### WORKFLOW OTIMIZADO:
```bash
# 1. Analisar complexidade
task-master analyze --task-id={id} --check-complexity

# 2. Se complexidade > 7, usar sequential
task-master process --task-id={id} --use-sequential --stages=auto

# 3. Revisar plano gerado
task-master review --show-thoughts --show-confidence

# 4. Executar com monitoramento
task-master execute --monitor --save-metrics
CACHE STRATEGY:
Thoughts válidos por 24h
Plans válidos por 12h
Invalidar cache ao modificar task
Compartilhar cache entre tasks similares
