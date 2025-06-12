# Algoritmo FMC Error Pattern Recognition Otimizado V4.0
function Test-EnhancedErrorPatternRecognition {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) { return $false }
    
    $content = Get-Content $FilePath -Raw
    
    # Padrões de erro expandidos (baseado em análise do self_correction_log.md)
    $errorPatterns = @(
        "erro", "error", "bug", "fail", "issue", "problem",
        "exception", "crash", "timeout", "conflict", "violation",
        "missing", "not found", "invalid", "incorrect", "mismatch",
        "corruption", "degradation", "failure", "malfunction"
    )
    
    # Padrões de aprendizado expandidos
    $learningPatterns = @(
        "LEARNINGS", "LEARNING", "APRENDIZADO", "SOLUÇÃO", "SOLUTION",
        "CORREÇÃO", "CORRECTION", "FIX", "RESOLVED", "IMPLEMENTADO",
        "SUCCESS", "SUCESSO", "ACHIEVEMENT", "IMPROVEMENT", "OTIMIZAÇÃO"
    )
    
    # Verificar se há pelo menos um padrão de erro E um padrão de aprendizado
    $hasErrorPattern = $false
    $hasLearningPattern = $false
    
    foreach ($pattern in $errorPatterns) {
        if ($content -match $pattern) {
            $hasErrorPattern = $true
            break
        }
    }
    
    foreach ($pattern in $learningPatterns) {
        if ($content -match $pattern) {
            $hasLearningPattern = $true
            break
        }
    }
    
    return $hasErrorPattern -and $hasLearningPattern
}
