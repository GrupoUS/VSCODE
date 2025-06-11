# Cenários de Teste Expandidos V4.0
# Baseados em casos de uso reais de desenvolvimento

function Test-ExpandedScenarios {
    $scenarios = @(
        # Cenários de Alta Complexidade (ARCHITECT)
        @{
            Name = "Migração de Arquitetura Microserviços"
            Complexity = 10
            Domain = @("architecture", "migration", "microservices")
            ExpectedAgent = "ARCHITECT"
            ExpectedMCP = @("sequential-thinking", "think-mcp-server", "mcp-shrimp")
            Description = "Migração de monolito para microserviços com Docker e Kubernetes"
        }
        @{
            Name = "Otimização de Performance de Banco de Dados"
            Complexity = 9
            Domain = @("performance", "database", "optimization")
            ExpectedAgent = "ARCHITECT"
            ExpectedMCP = @("sequential-thinking", "supabase")
            Description = "Análise e otimização de queries complexas com índices"
        }

        # Cenários de Complexidade Média-Alta (CODER)
        @{
            Name = "Implementação de Sistema de Autenticação JWT"
            Complexity = 8
            Domain = @("backend", "security", "authentication")
            ExpectedAgent = "CODER"
            ExpectedMCP = @("sequential-thinking", "think-mcp-server")
            Description = "Sistema completo de auth com refresh tokens e RLS"
        }
        @{
            Name = "Integração de API Externa com Rate Limiting"
            Complexity = 7
            Domain = @("api", "integration", "backend")
            ExpectedAgent = "CODER"
            ExpectedMCP = @("sequential-thinking")
            Description = "Integração robusta com fallback e retry strategies"
        }

        # Cenários de Complexidade Média (MANAGER)
        @{
            Name = "Coordenação de Deploy Multi-Ambiente"
            Complexity = 6
            Domain = @("coordination", "deployment", "workflow")
            ExpectedAgent = "MANAGER"
            ExpectedMCP = @("mcp-shrimp", "tavily")
            Description = "Pipeline de deploy para dev, staging e production"
        }
        @{
            Name = "Planejamento de Sprint com Estimativas"
            Complexity = 5
            Domain = @("planning", "project-management")
            ExpectedAgent = "MANAGER"
            ExpectedMCP = @("mcp-shrimp")
            Description = "Organização de tarefas com story points e dependencies"
        }

        # Cenários de Complexidade Baixa-Média (EXECUTOR)
        @{
            Name = "Criação de Componentes React com Tailwind"
            Complexity = 4
            Domain = @("frontend", "react", "styling")
            ExpectedAgent = "EXECUTOR"
            ExpectedMCP = @("figma", "playwright")
            Description = "Componentes responsivos com design system"
        }
        @{
            Name = "Implementação de Testes E2E com Playwright"
            Complexity = 3
            Domain = @("testing", "frontend", "automation")
            ExpectedAgent = "EXECUTOR"
            ExpectedMCP = @("playwright")
            Description = "Testes automatizados para user journeys críticos"
        }

        # Cenários de Complexidade Baixa (RESEARCHER)
        @{
            Name = "Pesquisa de Bibliotecas para Validação de Forms"
            Complexity = 2
            Domain = @("research", "libraries", "comparison")
            ExpectedAgent = "RESEARCHER"
            ExpectedMCP = @("tavily", "context7")
            Description = "Análise comparativa de Formik vs React Hook Form"
        }
        @{
            Name = "Documentação de API Endpoints"
            Complexity = 1
            Domain = @("documentation", "api")
            ExpectedAgent = "RESEARCHER"
            ExpectedMCP = @("tavily")
            Description = "Criação de documentação OpenAPI/Swagger"
        }
    )

    return $scenarios
}
