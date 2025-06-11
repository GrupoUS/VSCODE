# MCP Shrimp Task Manager - Auto Activation Configuration V4.0
# Tier 2: Coordenação e Execução

function Should-ActivateMCPShrimp {
    param(
        [int]$TaskComplexity,
        [string[]]$Domain,
        [string]$TaskType
    )
    
    # Ativação baseada em necessidade de coordenação (conforme constituição V4.0)
    $coordinationNeeded = $false
    
    # Critérios de ativação
    if ($TaskComplexity -ge 5) { $coordinationNeeded = $true }
    if ($Domain -contains "coordination") { $coordinationNeeded = $true }
    if ($Domain -contains "multi-agent") { $coordinationNeeded = $true }
    if ($Domain -contains "workflow") { $coordinationNeeded = $true }
    if ($TaskType -eq "project-management") { $coordinationNeeded = $true }
    if ($TaskType -eq "task-coordination") { $coordinationNeeded = $true }
    
    return $coordinationNeeded
}

# Exemplo de uso:
# $activate = Should-ActivateMCPShrimp -TaskComplexity 6 -Domain @("coordination", "backend") -TaskType "project-management"
