---
description: Regras para prevenir a reinstalação do MCP Knowledge Graph Memory Server.
globs: ["**/*"]
alwaysApply: true
---

# Regras de Prevenção do MCP Knowledge Graph Memory Server

- **NUNCA** instale ou configure o MCP Knowledge Graph Memory Server.
- Este ambiente de desenvolvimento **NÃO UTILIZA DOCKER**.
- O sistema de memória interna existente com `.clinerules` é suficiente.
- Qualquer persistência de memória deve usar o sistema de memory bank estabelecido.
- Se servidores MCP forem necessários, utilize **APENAS** servidores baseados em NPX que **NÃO REQUEREM DOCKER**.
- **SEMPRE** verifique os requisitos do Docker antes de instalar qualquer servidor MCP.
