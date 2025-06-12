# GRUPO US VIBECODE SYSTEM

Este projeto é a base do ecossistema GRUPO US VIBECODE SYSTEM, focado em automação, integração de agentes MCP e workflows inteligentes para desenvolvimento de software. Aqui você encontra a estrutura principal do sistema, incluindo automações, configurações, documentação, scripts e regras de orquestração. Consulte a pasta `docs/` para guias detalhados de setup, workflows de desenvolvimento, arquitetura e padrões. Para integrações avançadas, veja também `@project-core/knowledge-base/rules/` e `@project-core/configs/`. Este README serve como ponto de partida para desenvolvedores, arquitetos e gestores do GRUPO US.

# UserProfileCard Component

Um componente React reutilizável para exibir informações de perfil de usuário de forma consistente em toda a aplicação.

## 🚀 Características

- Design moderno e responsivo
- Suporte a tema claro/escuro
- Indicador de status online
- Estatísticas personalizáveis
- Totalmente tipado com TypeScript
- Documentado com Storybook

## 📦 Instalação

```bash
npm install
```

## 🔒 Segurança e Gestão de Secrets

O GRUPO US VIBECODE SYSTEM implementa um sistema robusto de segurança para proteger segredos e chaves de API. Siga estas instruções para configurar e manter a segurança do projeto:

### Configuração Inicial

1. Execute o script de configuração de segurança:

```bash
python setup_git_secrets.py
```

Este script irá:

- Instalar e configurar o `git-secrets`
- Configurar hooks para prevenir commits com segredos
- Criar um arquivo `.env.example` como modelo

### Gestão de Variáveis de Ambiente

1. Copie o arquivo `.env.example` para `.env`:

```bash
cp .env.example .env
```

2. Preencha as variáveis no arquivo `.env` com seus valores reais
3. **IMPORTANTE**: Nunca comite o arquivo `.env` ou outros arquivos contendo segredos

### Validação de Segurança

O sistema implementa múltiplas camadas de segurança:

1. **Pre-commit Hook:**

   - Bloqueia automaticamente commits contendo secrets
   - Verifica padrões comuns de chaves de API e tokens
   - Valida arquivos `.env` não autorizados

2. **GitHub Actions:**

   - Executa verificações de segurança em cada push/PR
   - Valida a ausência de secrets no código
   - Garante conformidade com as políticas de segurança

3. **Script de Sincronização:**
   - Valida segurança antes de cada sync
   - Integra com git-secrets para verificação
   - Previne push de commits inseguros

### GitHub Secrets

Para usar secrets no GitHub Actions:

1. Acesse `Settings > Secrets and variables > Actions`
2. Adicione os secrets necessários:
   - `SUPABASE_API_KEY`
   - `ANTHROPIC_API_KEY`
   - `OPENROUTER_API_KEY`
   - Outros conforme necessário

Consulte `docs/github-actions-secrets.md` para detalhes completos.

### Boas Práticas

- Use sempre variáveis de ambiente para segredos
- Mantenha o arquivo `.env` no `.gitignore`
- Revise o código antes de commitar
- Use o `git-secrets` para verificar commits:

```bash
git secrets --scan
```

### Troubleshooting

Se encontrar problemas:

1. Verifique se o git-secrets está instalado:

```bash
git secrets --version
```

2. Reconfigure os hooks se necessário:

```bash
git secrets --install -f
```

3. Consulte a documentação em `docs/github-actions-secrets.md`

## 🎨 Uso

```tsx
import { UserProfileCard } from "@/components/UserProfileCard";

const MyComponent = () => {
  return (
    <UserProfileCard
      avatarUrl="https://github.com/shadcn.png"
      name="João Silva"
      username="@joaosilva"
      bio="Desenvolvedor Full Stack apaixonado por React e TypeScript"
      stats={[
        { label: "Seguidores", value: 1234 },
        { label: "Seguindo", value: 567 },
        { label: "Posts", value: 89 },
      ]}
      isOnline={true}
    />
  );
};
```

## 📋 Props

| Prop        | Tipo                                      | Descrição                                         |
| ----------- | ----------------------------------------- | ------------------------------------------------- |
| `avatarUrl` | `string`                                  | URL da imagem do avatar do usuário                |
| `name`      | `string`                                  | Nome completo do usuário                          |
| `username`  | `string`                                  | Nome de usuário (ex: @usuario)                    |
| `bio`       | `string`                                  | Biografia curta do usuário                        |
| `stats`     | `Array<{ label: string; value: number }>` | Array de estatísticas do usuário                  |
| `isOnline`  | `boolean`                                 | Controla a exibição do indicador de status online |
| `className` | `string`                                  | Classes CSS adicionais para customização          |

## 🎯 Exemplos

### Status Online

```tsx
<UserProfileCard {...defaultProps} isOnline={true} />
```

### Bio Longa

```tsx
<UserProfileCard
  {...defaultProps}
  bio="Desenvolvedor Full Stack com mais de 5 anos de experiência em React, TypeScript, Node.js e Python. Apaixonado por criar interfaces intuitivas e experiências de usuário excepcionais."
/>
```

### Estatísticas Personalizadas

```tsx
<UserProfileCard
  {...defaultProps}
  stats={[
    { label: "Projetos", value: 42 },
    { label: "Contribuições", value: 789 },
    { label: "Stars", value: 123 },
  ]}
/>
```

## 🧪 Desenvolvimento

```bash
# Instalar dependências
npm install

# Iniciar Storybook
npm run storybook

# Executar testes
npm test

# Build do projeto
npm run build
```

## 📚 Documentação

A documentação completa do componente está disponível no Storybook. Para visualizar:

```bash
npm run storybook
```

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
