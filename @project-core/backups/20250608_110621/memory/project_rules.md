# Visão Geral do Produto: TaskMaster + Sequential Thinking Integration
* **Tipo:** Sistema de Coordenação AI Híbrido
* **Descrição:** Integração inteligente entre TaskMaster (gerenciamento de tarefas) e Sequential Thinking (análise e raciocínio) para desenvolvimento coordenado e otimizado
* **Meta Principal:** Criar um sistema que decide automaticamente quando usar cada ferramenta baseado em contexto, complexidade e padrões aprendidos

# Stack Tecnológica
* **Runtime:** Node.js
* **Linguagem:** JavaScript
* **Sistemas Integrados:** TaskMaster CLI, Sequential Thinking MCP Server
* **Coordenação:** Advanced Rules Engine com aprendizado de máquina
* **Comunicação:** MCP (Model Context Protocol)
* **Logging:** Sistema unificado com Winston-style logging
* **Testes:** Jest-style testing com scripts personalizados

# Regras de Desenvolvimento
* **Linguagem:** JavaScript (ES6+) com async/await
* **Estilo de Código:** 
  - Usar camelCase para variáveis e funções
  - Usar PascalCase para classes
  - Usar kebab-case para arquivos
  - Sempre usar const/let, nunca var
  - Preferir arrow functions para callbacks
* **Estrutura de Arquivos:**
  - `src/core/` - Componentes principais (coordinator, rules-engine, sync-manager)
  - `src/utils/` - Utilitários (logger, context-manager)
  - `src/interfaces/` - Interfaces de comunicação
  - `test-*.js` - Scripts de teste na raiz
  - `docs/` - Documentação

# Regras de Coordenação TaskMaster + Sequential Thinking
* **Prioridade TaskMaster:** Operações CRUD de tarefas, gerenciamento de dependências, estruturação
* **Prioridade Sequential Thinking:** Análise complexa (complexity > 7), resolução de problemas, validação
* **Operações Híbridas:** Planejamento estratégico, análise seguida de estruturação, validação de soluções
* **Handoff Automático:** Baseado em keywords, contexto e complexidade
* **Logging Obrigatório:** Todas as decisões devem ser logadas para aprendizado

# Padrões de Implementação
* **Error Handling:** Sempre usar try-catch com fallback para TaskMaster
* **Logging:** Usar Logger class com níveis (info, warn, error)
* **Async Operations:** Sempre usar async/await, nunca callbacks
* **Configuration:** Usar arquivos JSON para configuração, .env para secrets
* **Testing:** Cada componente deve ter script de teste correspondente

# Métricas e Aprendizado
* **Decision Tracking:** Todas as decisões do Rules Engine devem ser rastreadas
* **Performance Metrics:** Tempo de execução, taxa de sucesso, confiança média
* **Learning Patterns:** Padrões bem-sucedidos devem ser persistidos e reutilizados
* **Continuous Improvement:** Sistema deve evoluir baseado em feedback e resultados

# Estrutura de Dados
* **Tasks JSON:** Estrutura hierárquica com id, title, description, status, dependencies, priority, details, testStrategy, subtasks
* **Config JSON:** Configuração de modelos AI, parâmetros, logging level
* **Decision History:** Array de decisões com timestamp, contexto, resultado, sucesso
* **Learning Patterns:** Map de padrões com chave, sistema preferido, confiança, ocorrências

# Comandos Essenciais
* **TaskMaster CLI:** `task-master list`, `task-master next`, `task-master show <id>`, `task-master set-status`
* **Testes:** `node test-coordination.js`, `node test-advanced-rules.js`
* **Desenvolvimento:** Sempre testar após mudanças, manter logs limpos, documentar decisões importantes

## Padrão de Qualidade e Revisão Contínua

Após a implementação de qualquer nova funcionalidade, correção de bug ou alteração significativa no código, você DEVE, obrigatoriamente, iniciar uma rotina de "Micro-Auditoria" na área do projeto que foi modificada.

Esta **Micro-Auditoria** inclui as seguintes verificações:

1.  **Revisão de Código Imediata:** Analise o novo código em busca de erros, inconsistências de estilo ou lógica falha.
2.  **Verificação de Regressão de Performance:** Certifique-se de que a alteração não introduziu novos gargalos de performance (ex: loops ineficientes, aumento do tempo de carregamento do componente).
3.  **Checagem de Responsividade e UX:** Se a alteração envolveu a interface, confirme que os novos elementos são responsivos e mantêm a fluidez da experiência do usuário.
4.  **Validação de SEO:** Se uma nova página ou rota foi criada, confirme que as meta tags básicas (`title`, `description`) e a tag `H1` foram adicionadas corretamente.
5.  **Teste de Links:** Verifique se todos os novos links adicionados estão funcionando.

Esta rotina garante que o nosso padrão de qualidade "impecável" seja mantido de forma contínua e proativa, evitando o acúmulo de débito técnico.
