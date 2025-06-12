# Performance Optimization Script para Shrimp Task Manager
# GRUPO US VIBECODE SYSTEM V4.0

param(
    [string]$ConfigPath = "@project-core/memory/coordination/shrimp-task-manager-config.json",
    [string]$MetricsPath = "@project-core/monitoring/metrics",
    [switch]$DryRun = $false,
    [switch]$Verbose = $false
)

Write-Host "🚀 SHRIMP TASK MANAGER PERFORMANCE OPTIMIZER V4.0" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# Função para logging
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARNING" { "Yellow" }
        "SUCCESS" { "Green" }
        default { "White" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

# Função para carregar configuração
function Load-Configuration {
    param([string]$Path)

    try {
        if (-not (Test-Path $Path)) {
            Write-Log "Configuration file not found: $Path" "ERROR"
            return $null
        }

        $config = Get-Content $Path -Raw | ConvertFrom-Json
        Write-Log "Configuration loaded successfully from $Path" "SUCCESS"
        return $config
    }
    catch {
        Write-Log "Error loading configuration: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Função para analisar métricas de performance
function Analyze-PerformanceMetrics {
    param([string]$MetricsPath)

    Write-Log "Analyzing performance metrics..."

    if (-not (Test-Path $MetricsPath)) {
        Write-Log "Metrics directory not found: $MetricsPath" "WARNING"
        return @{
            AvgTaskCompletionRate = 0.95
            AvgExecutionTime = 2000
            ErrorRate = 0.02
            ShrimpSuccessRate = 0.98
            RecommendedOptimizations = @()
        }
    }

    # Busca os arquivos de métricas mais recentes
    $metricFiles = Get-ChildItem $MetricsPath -Filter "metrics-*.json" |
                   Sort-Object LastWriteTime -Descending |
                   Select-Object -First 5

    if ($metricFiles.Count -eq 0) {
        Write-Log "No metrics files found" "WARNING"
        return @{
            AvgTaskCompletionRate = 0.95
            AvgExecutionTime = 2000
            ErrorRate = 0.02
            ShrimpSuccessRate = 0.98
            RecommendedOptimizations = @()
        }
    }

    $totalCompletionRate = 0
    $totalExecutionTime = 0
    $totalErrorRate = 0
    $totalShrimpSuccess = 0
    $count = 0

    foreach ($file in $metricFiles) {
        try {
            $metrics = Get-Content $file.FullName -Raw | ConvertFrom-Json
            $totalCompletionRate += $metrics.summary.taskCompletionRate
            $totalExecutionTime += $metrics.summary.averageExecutionTime
            $totalErrorRate += $metrics.summary.errorRate
            $totalShrimpSuccess += $metrics.summary.shrimpSuccessRate
            $count++
        }
        catch {
            Write-Log "Error reading metrics file $($file.Name): $($_.Exception.Message)" "WARNING"
        }
    }

    if ($count -eq 0) {
        Write-Log "No valid metrics found" "WARNING"
        return @{
            AvgTaskCompletionRate = 0.95
            AvgExecutionTime = 2000
            ErrorRate = 0.02
            ShrimpSuccessRate = 0.98
            RecommendedOptimizations = @()
        }
    }

    $analysis = @{
        AvgTaskCompletionRate = $totalCompletionRate / $count
        AvgExecutionTime = $totalExecutionTime / $count
        ErrorRate = $totalErrorRate / $count
        ShrimpSuccessRate = $totalShrimpSuccess / $count
        RecommendedOptimizations = @()
    }

    # Análise e recomendações
    if ($analysis.AvgTaskCompletionRate -lt 0.90) {
        $analysis.RecommendedOptimizations += "INCREASE_RETRY_ATTEMPTS"
        $analysis.RecommendedOptimizations += "ENABLE_FALLBACK_MECHANISMS"
    }

    if ($analysis.AvgExecutionTime -gt 5000) {
        $analysis.RecommendedOptimizations += "OPTIMIZE_PROMPTS_FOR_SPEED"
        $analysis.RecommendedOptimizations += "ENABLE_PARALLEL_PROCESSING"
        $analysis.RecommendedOptimizations += "CACHE_INTERMEDIATE_RESULTS"
    }

    if ($analysis.ErrorRate -gt 0.05) {
        $analysis.RecommendedOptimizations += "IMPROVE_ERROR_HANDLING"
        $analysis.RecommendedOptimizations += "INCREASE_CONFIDENCE_THRESHOLD"
    }

    if ($analysis.ShrimpSuccessRate -lt 0.95) {
        $analysis.RecommendedOptimizations += "OPTIMIZE_THOUGHT_CHAIN"
        $analysis.RecommendedOptimizations += "ADJUST_MAX_ITERATIONS"
    }

    Write-Log "Performance analysis completed:" "SUCCESS"
    Write-Log "  Task Completion Rate: $($analysis.AvgTaskCompletionRate.ToString('P2'))"
    Write-Log "  Average Execution Time: $($analysis.AvgExecutionTime.ToString('N0'))ms"
    Write-Log "  Error Rate: $($analysis.ErrorRate.ToString('P2'))"
    Write-Log "  Shrimp Success Rate: $($analysis.ShrimpSuccessRate.ToString('P2'))"

    return $analysis
}

# Função para aplicar otimizações
function Apply-Optimizations {
    param(
        [PSCustomObject]$Config,
        [array]$Optimizations,
        [string]$ConfigPath,
        [bool]$DryRun
    )

    Write-Log "Applying performance optimizations..."
    $optimizationsApplied = 0

    foreach ($optimization in $Optimizations) {
        switch ($optimization) {
            "INCREASE_RETRY_ATTEMPTS" {
                if ($Config.ERROR_HANDLING.MAX_RETRIES -lt 5) {
                    Write-Log "Increasing MAX_RETRIES from $($Config.ERROR_HANDLING.MAX_RETRIES) to 5"
                    $Config.ERROR_HANDLING.MAX_RETRIES = 5
                    $optimizationsApplied++
                }
            }

            "ENABLE_FALLBACK_MECHANISMS" {
                if (-not $Config.FALLBACK_MECHANISMS.ALTERNATIVE_AGENTS) {
                    Write-Log "Enabling fallback mechanisms"
                    $Config.FALLBACK_MECHANISMS.ALTERNATIVE_AGENTS = $true
                    $Config.FALLBACK_MECHANISMS.SIMPLIFIED_WORKFLOWS = $true
                    $optimizationsApplied++
                }
            }

            "OPTIMIZE_PROMPTS_FOR_SPEED" {
                if (-not $Config.PERFORMANCE_OPTIMIZATION.OPTIMIZE_PROMPTS_FOR_SPEED) {
                    Write-Log "Enabling prompt optimization for speed"
                    $Config.PERFORMANCE_OPTIMIZATION.OPTIMIZE_PROMPTS_FOR_SPEED = $true
                    $optimizationsApplied++
                }
            }

            "ENABLE_PARALLEL_PROCESSING" {
                if (-not $Config.PERFORMANCE_OPTIMIZATION.ENABLE_PARALLEL_PROCESSING) {
                    Write-Log "Enabling parallel processing"
                    $Config.PERFORMANCE_OPTIMIZATION.ENABLE_PARALLEL_PROCESSING = $true
                    $optimizationsApplied++
                }
            }

            "CACHE_INTERMEDIATE_RESULTS" {
                if (-not $Config.PERFORMANCE_OPTIMIZATION.CACHE_INTERMEDIATE_RESULTS) {
                    Write-Log "Enabling intermediate results caching"
                    $Config.PERFORMANCE_OPTIMIZATION.CACHE_INTERMEDIATE_RESULTS = $true
                    $optimizationsApplied++
                }
            }

            "IMPROVE_ERROR_HANDLING" {
                if (-not $Config.ERROR_HANDLING.ENABLE_DETAILED_LOGGING) {
                    Write-Log "Improving error handling and logging"
                    $Config.ERROR_HANDLING.ENABLE_DETAILED_LOGGING = $true
                    $Config.ERROR_HANDLING.LOG_ERRORS = $true
                    $optimizationsApplied++
                }
            }

            "INCREASE_CONFIDENCE_THRESHOLD" {
                if ($Config.CONFIDENCE_THRESHOLD -lt 0.8) {
                    $oldThreshold = $Config.CONFIDENCE_THRESHOLD
                    $Config.CONFIDENCE_THRESHOLD = 0.8
                    Write-Log "Increasing confidence threshold from $oldThreshold to 0.8"
                    $optimizationsApplied++
                }
            }

            "OPTIMIZE_THOUGHT_CHAIN" {
                if ($Config.MAX_ITERATIONS -gt 10) {
                    $oldIterations = $Config.MAX_ITERATIONS
                    $Config.MAX_ITERATIONS = 8
                    Write-Log "Optimizing thought chain iterations from $oldIterations to 8"
                    $optimizationsApplied++
                }
            }

            "ADJUST_MAX_ITERATIONS" {
                if ($Config.MAX_ITERATIONS -lt 5) {
                    $oldIterations = $Config.MAX_ITERATIONS
                    $Config.MAX_ITERATIONS = 6
                    Write-Log "Adjusting max iterations from $oldIterations to 6"
                    $optimizationsApplied++
                }
            }
        }
    }

    if ($optimizationsApplied -gt 0) {
        if ($DryRun) {
            Write-Log "DRY RUN: Would apply $optimizationsApplied optimizations" "WARNING"
        }
        else {
            try {
                # Backup da configuração atual
                $backupPath = $ConfigPath + ".backup." + (Get-Date -Format "yyyyMMdd-HHmmss")
                Copy-Item $ConfigPath $backupPath
                Write-Log "Configuration backed up to $backupPath"

                # Salva a configuração otimizada
                $Config | ConvertTo-Json -Depth 10 | Set-Content $ConfigPath -Encoding UTF8
                Write-Log "Applied $optimizationsApplied optimizations successfully" "SUCCESS"
            }
            catch {
                Write-Log "Error saving optimized configuration: $($_.Exception.Message)" "ERROR"
                return $false
            }
        }
    }
    else {
        Write-Log "No optimizations needed - configuration is already optimal" "SUCCESS"
    }

    return $true
}

# Função para validar otimizações
function Test-OptimizedConfiguration {
    param([PSCustomObject]$Config)

    Write-Log "Validating optimized configuration..."

    $validationErrors = @()

    # Validações de configuração
    if ($Config.MAX_ITERATIONS -lt 1 -or $Config.MAX_ITERATIONS -gt 20) {
        $validationErrors += "MAX_ITERATIONS must be between 1 and 20"
    }

    if ($Config.CONFIDENCE_THRESHOLD -lt 0.5 -or $Config.CONFIDENCE_THRESHOLD -gt 1.0) {
        $validationErrors += "CONFIDENCE_THRESHOLD must be between 0.5 and 1.0"
    }

    if ($Config.ERROR_HANDLING.MAX_RETRIES -lt 1 -or $Config.ERROR_HANDLING.MAX_RETRIES -gt 10) {
        $validationErrors += "MAX_RETRIES must be between 1 and 10"
    }

    if ($validationErrors.Count -gt 0) {
        Write-Log "Configuration validation failed:" "ERROR"
        foreach ($error in $validationErrors) {
            Write-Log "  - $error" "ERROR"
        }
        return $false
    }

    Write-Log "Configuration validation passed" "SUCCESS"
    return $true
}

# Função para gerar relatório de otimização
function Generate-OptimizationReport {
    param(
        [hashtable]$Analysis,
        [array]$Optimizations,
        [bool]$Applied
    )

    $reportPath = "@project-core/monitoring/optimization-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"

    $report = @{
        timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        analysis = $Analysis
        recommendedOptimizations = $Optimizations
        optimizationsApplied = $Applied
        summary = @{
            totalOptimizations = $Optimizations.Count
            performanceScore = [Math]::Round(
                ($Analysis.AvgTaskCompletionRate * 0.3 +
                 (1 - [Math]::Min($Analysis.AvgExecutionTime / 10000, 1)) * 0.3 +
                 (1 - $Analysis.ErrorRate) * 0.2 +
                 $Analysis.ShrimpSuccessRate * 0.2) * 100, 2)
        }
    }

    try {
        # Cria diretório se não existir
        $reportDir = Split-Path $reportPath -Parent
        if (-not (Test-Path $reportDir)) {
            New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
        }

        $report | ConvertTo-Json -Depth 10 | Set-Content $reportPath -Encoding UTF8
        Write-Log "Optimization report saved to $reportPath" "SUCCESS"
        Write-Log "Performance Score: $($report.summary.performanceScore)%" "SUCCESS"
    }
    catch {
        Write-Log "Error saving optimization report: $($_.Exception.Message)" "ERROR"
    }
}

# Script principal
try {
    Write-Log "Starting Shrimp Task Manager Performance Optimization"

    # Carrega configuração
    $config = Load-Configuration -Path $ConfigPath
    if (-not $config) {
        Write-Log "Failed to load configuration. Exiting." "ERROR"
        exit 1
    }

    # Analisa métricas de performance
    $analysis = Analyze-PerformanceMetrics -MetricsPath $MetricsPath

    # Aplica otimizações se necessário
    $optimizationsApplied = $false
    if ($analysis.RecommendedOptimizations.Count -gt 0) {
        Write-Log "Found $($analysis.RecommendedOptimizations.Count) recommended optimizations"

        if ($Verbose) {
            Write-Log "Recommended optimizations:"
            foreach ($opt in $analysis.RecommendedOptimizations) {
                Write-Log "  - $opt"
            }
        }

        $optimizationsApplied = Apply-Optimizations -Config $config -Optimizations $analysis.RecommendedOptimizations -ConfigPath $ConfigPath -DryRun $DryRun

        if ($optimizationsApplied -and -not $DryRun) {
            # Valida configuração otimizada
            $config = Load-Configuration -Path $ConfigPath
            if (-not (Test-OptimizedConfiguration -Config $config)) {
                Write-Log "Optimized configuration failed validation" "ERROR"
                exit 1
            }
        }
    }
    else {
        Write-Log "No optimizations needed - system is performing well" "SUCCESS"
    }

    # Gera relatório
    Generate-OptimizationReport -Analysis $analysis -Optimizations $analysis.RecommendedOptimizations -Applied $optimizationsApplied

    Write-Log "Performance optimization completed successfully" "SUCCESS"

    if ($DryRun) {
        Write-Log "DRY RUN completed - no changes were made" "WARNING"
    }
}
catch {
    Write-Log "Performance optimization failed: $($_.Exception.Message)" "ERROR"
    Write-Log "Stack trace: $($_.ScriptStackTrace)" "ERROR"
    exit 1
}

Write-Host "`n🎯 OPTIMIZATION COMPLETE" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green
