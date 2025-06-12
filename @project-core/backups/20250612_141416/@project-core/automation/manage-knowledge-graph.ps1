# GRUPO US VIBECODE SYSTEM V4.5 - Knowledge Graph Manager
# Script para gerenciar o knowledge graph do sistema

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("add-solution", "add-context", "add-pattern", "query", "optimize", "stats")]
    [string]$Action,

    [Parameter(Mandatory=$false)]
    [string]$SolutionId,

    [Parameter(Mandatory=$false)]
    [string]$ContextId,

    [Parameter(Mandatory=$false)]
    [string]$PatternId,

    [Parameter(Mandatory=$false)]
    [string]$Query,

    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Configurações
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$KNOWLEDGE_GRAPH_PATH = Join-Path $SCRIPT_DIR "..\memory\knowledge_graph.json"
$OPTIMIZATION_THRESHOLD = 1000 # Número de entradas antes de otimizar

# Função para carregar o knowledge graph
function Load-KnowledgeGraph {
    if (Test-Path $KNOWLEDGE_GRAPH_PATH) {
        $graphContent = Get-Content $KNOWLEDGE_GRAPH_PATH -Raw
        return $graphContent | ConvertFrom-Json
    } else {
        Write-Error "❌ Knowledge graph file not found at $KNOWLEDGE_GRAPH_PATH"
        exit 1
    }
}

# Função para salvar o knowledge graph
function Save-KnowledgeGraph {
    param($graph)

    $graph.lastUpdated = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $graph.metadata.totalSolutions = $graph.solutions.Count
    $graph.metadata.totalContexts = $graph.contexts.Count

    $graphJson = $graph | ConvertTo-Json -Depth 10
    Set-Content -Path $KNOWLEDGE_GRAPH_PATH -Value $graphJson
}

# Função para adicionar uma solução
function Add-Solution {
    param(
        [string]$id,
        [string]$description,
        [string]$type,
        [string]$content,
        [string[]]$tags
    )

    $graph = Load-KnowledgeGraph

    $solution = @{
        id = $id
        description = $description
        type = $type
        content = $content
        tags = $tags
        createdAt = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        lastUpdated = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    }

    $graph.solutions += $solution
    Save-KnowledgeGraph -graph $graph

    Write-Host "✅ Solution added successfully: $id"
}

# Função para adicionar um contexto
function Add-Context {
    param(
        [string]$id,
        [string]$description,
        [string]$type,
        [string]$content,
        [string[]]$relatedSolutions
    )

    $graph = Load-KnowledgeGraph

    $context = @{
        id = $id
        description = $description
        type = $type
        content = $content
        relatedSolutions = $relatedSolutions
        createdAt = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        lastUpdated = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    }

    $graph.contexts += $context

    # Atualizar relacionamentos
    foreach ($solutionId in $relatedSolutions) {
        if (-not $graph.relationships.solutionToContexts.$solutionId) {
            $graph.relationships.solutionToContexts.$solutionId = @()
        }
        $graph.relationships.solutionToContexts.$solutionId += $id
    }

    Save-KnowledgeGraph -graph $graph

    Write-Host "✅ Context added successfully: $id"
}

# Função para adicionar um padrão
function Add-Pattern {
    param(
        [string]$id,
        [string]$type,
        [string]$description,
        [string]$content,
        [string[]]$relatedSolutions,
        [string[]]$relatedContexts
    )

    $graph = Load-KnowledgeGraph

    $pattern = @{
        id = $id
        type = $type
        description = $description
        content = $content
        relatedSolutions = $relatedSolutions
        relatedContexts = $relatedContexts
        createdAt = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        lastUpdated = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    }

    if ($type -eq "success") {
        $graph.patterns.success += $pattern
    } else {
        $graph.patterns.error += $pattern
    }

    # Atualizar relacionamentos
    foreach ($solutionId in $relatedSolutions) {
        if (-not $graph.relationships.patternToSolutions.$id) {
            $graph.relationships.patternToSolutions.$id = @()
        }
        $graph.relationships.patternToSolutions.$id += $solutionId
    }

    foreach ($contextId in $relatedContexts) {
        if (-not $graph.relationships.contextToPatterns.$contextId) {
            $graph.relationships.contextToPatterns.$contextId = @()
        }
        $graph.relationships.contextToPatterns.$contextId += $id
    }

    Save-KnowledgeGraph -graph $graph

    Write-Host "✅ Pattern added successfully: $id"
}

# Função para consultar o knowledge graph
function Query-KnowledgeGraph {
    param([string]$query)

    $graph = Load-KnowledgeGraph

    # Implementar lógica de consulta baseada no tipo de query
    # Por enquanto, apenas uma busca simples
    $results = @()

    # Buscar em soluções
    $results += $graph.solutions | Where-Object {
        $_.description -like "*$query*" -or
        $_.content -like "*$query*" -or
        $_.tags -like "*$query*"
    }

    # Buscar em contextos
    $results += $graph.contexts | Where-Object {
        $_.description -like "*$query*" -or
        $_.content -like "*$query*"
    }

    # Buscar em padrões
    $results += $graph.patterns.success | Where-Object {
        $_.description -like "*$query*" -or
        $_.content -like "*$query*"
    }
    $results += $graph.patterns.error | Where-Object {
        $_.description -like "*$query*" -or
        $_.content -like "*$query*"
    }

    return $results
}

# Função para otimizar o knowledge graph
function Optimize-KnowledgeGraph {
    param([switch]$Force)
    $graph = Load-KnowledgeGraph
    $totalEntries = ($graph.solutions.Count + $graph.contexts.Count + $graph.patterns.Count)
    if (-not $Force -and $totalEntries -lt $OPTIMIZATION_THRESHOLD) {
        Write-Host "Knowledge graph doesn't need optimization yet"
        return
    }
    # Otimização fictícia para exemplo
    Write-Host "Optimizing knowledge graph..."
    # Aqui entraria a lógica real de otimização
    $graph.metadata.lastUpdated = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ssZ')
    Save-KnowledgeGraph -graph $graph
    Write-Host "Knowledge graph optimized."
}

# Função para mostrar estatísticas
function Show-KnowledgeGraphStats {
    $graph = Load-KnowledgeGraph
    Write-Host ""
    Write-Host "Knowledge Graph Statistics:"
    Write-Host "Solutions: $($graph.solutions.Count)"
    Write-Host "Contexts: $($graph.contexts.Count)"
    Write-Host "Success Patterns: $($graph.patterns.success.Count)"
    Write-Host "Error Patterns: $($graph.patterns.error.Count)"
    Write-Host "Last Updated: $($graph.metadata.lastUpdated)"
    Write-Host "Version: $($graph.metadata.version)"
}

# Main execution
switch ($Action) {
    "add-solution" {
        if (-not $SolutionId) {
            Write-Error "❌ SolutionId is required for add-solution action"
            exit 1
        }
        Add-Solution -id $SolutionId
    }
    "add-context" {
        if (-not $ContextId) {
            Write-Error "❌ ContextId is required for add-context action"
            exit 1
        }
        Add-Context -id $ContextId
    }
    "add-pattern" {
        if (-not $PatternId) {
            Write-Error "❌ PatternId is required for add-pattern action"
            exit 1
        }
        Add-Pattern -id $PatternId
    }
    "query" {
        if (-not $Query) {
            Write-Error "❌ Query is required for query action"
            exit 1
        }
        $results = Query-KnowledgeGraph -query $Query
        $results | Format-Table -AutoSize
    }
    "optimize" {
        Optimize-KnowledgeGraph -Force:$Force
    }
    "stats" {
        Show-KnowledgeGraphStats
    }
    default {
        Write-Host "Usage: .\manage-knowledge-graph.ps1 [-Action action] [parameters]"
        Write-Host "Available actions:"
        Write-Host "  add-solution   - Add a new solution"
        Write-Host "  add-context    - Add a new context"
        Write-Host "  add-pattern    - Add a new pattern"
        Write-Host "  query          - Query the knowledge graph"
        Write-Host "  optimize       - Optimize the knowledge graph"
        Write-Host "  stats          - Show knowledge graph statistics"
    }
}
