# Sequential Thinking MCP - Ativação Otimizada V4.0
# Precisão aprimorada para complexidade ≥7

function Should-ActivateSequentialThinking {
    param(
        [int]$TaskComplexity,
        [string[]]$Domain,
        [string]$TaskType,
        [hashtable]$Context = @{}
    )

    # Critérios primários (complexidade ≥7)
    if ($TaskComplexity -ge 7) {
        return @{
            Activate = $true
            Reason = "Primary criteria: Complexity ≥7"
            Confidence = 10
            Mode = "full-analysis"
        }
    }

    # Critérios secundários (domínios que requerem raciocínio complexo)
    $complexReasoningDomains = @(
        "architecture", "migration", "refactor", "optimization",
        "debugging", "performance", "security", "integration",
        "multi-agent", "coordination", "system-design"
    )

    $requiresComplexReasoning = $false
    foreach ($domain in $Domain) {
        if ($complexReasoningDomains -contains $domain) {
            $requiresComplexReasoning = $true
            break
        }
    }

    if ($requiresComplexReasoning -and $TaskComplexity -ge 5) {
        return @{
            Activate = $true
            Reason = "Secondary criteria: Complex reasoning domain with complexity ≥5"
            Confidence = 8
            Mode = "targeted-analysis"
        }
    }

    # Critérios terciários (tipos de tarefa específicos)
    $complexTaskTypes = @(
        "problem-solving", "root-cause-analysis", "strategic-planning",
        "architectural-review", "performance-optimization"
    )

    if ($complexTaskTypes -contains $TaskType) {
        return @{
            Activate = $true
            Reason = "Tertiary criteria: Complex task type"
            Confidence = 7
            Mode = "focused-analysis"
        }
    }

    # Não ativar
    return @{
        Activate = $false
        Reason = "Criteria not met for Sequential Thinking activation"
        Confidence = 9
        Mode = "none"
    }
}
