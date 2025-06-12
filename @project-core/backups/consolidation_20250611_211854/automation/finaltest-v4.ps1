# 🚀 VIBECODE SYSTEM V4.0 - FINAL VALIDATION SCRIPT
# GRUPO US - Validação Completa da Evolução Arquitetural

param(
    [switch]$Detailed,
    [switch]$MemoryCheck,
    [switch]$ConfigCheck
)

Write-Host "🚀 VIBECODE SYSTEM V4.0 - FINAL VALIDATION" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

$script:TestResults = @()
$script:TotalTests = 0
$script:PassedTests = 0
$script:FailedTests = 0

function Test-Component {
    param(
        [string]$Name,
        [scriptblock]$Test,
        [string]$Category = "General"
    )
    
    $script:TotalTests++
    Write-Host "🔍 Testing: $Name" -ForegroundColor Yellow
    
    try {
        $result = & $Test
        if ($result) {
            Write-Host "✅ PASS: $Name" -ForegroundColor Green
            $script:PassedTests++
            $script:TestResults += [PSCustomObject]@{
                Category = $Category
                Test = $Name
                Status = "PASS"
                Details = "OK"
            }
        } else {
            Write-Host "❌ FAIL: $Name" -ForegroundColor Red
            $script:FailedTests++
            $script:TestResults += [PSCustomObject]@{
                Category = $Category
                Test = $Name
                Status = "FAIL"
                Details = "Test returned false"
            }
        }
    }
    catch {
        Write-Host "❌ ERROR: $Name - $($_.Exception.Message)" -ForegroundColor Red
        $script:FailedTests++
        $script:TestResults += [PSCustomObject]@{
            Category = $Category
            Test = $Name
            Status = "ERROR"
            Details = $_.Exception.Message
        }
    }
}

# ===== FASE 1: VALIDAÇÃO DA CONSTITUIÇÃO V4.0 =====
Write-Host "`n📋 FASE 1: VALIDAÇÃO DA CONSTITUIÇÃO V4.0" -ForegroundColor Magenta

Test-Component "Constituição V4.0 existe" {
    Test-Path "@project-core/rules/00-vibecode-system-v4-master.md" -PathType Leaf
} "Constitution"

Test-Component "Constituição V4.0 contém FMC" {
    $content = Get-Content "@project-core/rules/00-vibecode-system-v4-master.md" -Raw
    $content -match "FMC.*Fusão de Memória Cognitiva"
} "Constitution"

Test-Component "Constituição V4.0 contém Multi-Agente" {
    $content = Get-Content "@project-core/rules/00-vibecode-system-v4-master.md" -Raw
    $content -match "BOOMERANG" -and $content -match "ARCHITECT.*CODER.*MANAGER.*EXECUTOR.*RESEARCHER"
} "Constitution"

Test-Component "Constituição V4.0 contém protocolos MCP" {
    $content = Get-Content "@project-core/rules/00-vibecode-system-v4-master.md" -Raw
    $content -match "Sequential Thinking" -and $content -match "MCP Shrimp"
} "Constitution"

# ===== FASE 2: VALIDAÇÃO DO SISTEMA FMC =====
Write-Host "`n🧠 FASE 2: VALIDAÇÃO DO SISTEMA FMC" -ForegroundColor Magenta

Test-Component "Memory Bank existe" {
    Test-Path "@project-core/memory" -PathType Container
} "FMC"

Test-Component "master_rule.md existe" {
    Test-Path "master_rule.md" -PathType Leaf
} "FMC"

Test-Component "self_correction_log.md existe" {
    Test-Path "@project-core/memory/self_correction_log.md" -PathType Leaf
} "FMC"

Test-Component "global-standards.md existe" {
    Test-Path "@project-core/memory/global-standards.md" -PathType Leaf
} "FMC"

Test-Component "Self correction log contém aprendizados V4.0" {
    if (Test-Path "@project-core/memory/self_correction_log.md") {
        $content = Get-Content "@project-core/memory/self_correction_log.md" -Raw
        $content -match "VIBECODE.*V4" -or $content -match "think-mcp-server" -or $content -match "Sequential Thinking"
    } else { $false }
} "FMC"

# ===== FASE 3: VALIDAÇÃO DAS CONFIGURAÇÕES V4.0 =====
Write-Host "`n🔧 FASE 3: VALIDAÇÃO DAS CONFIGURAÇÕES V4.0" -ForegroundColor Magenta

Test-Component "Manifesto Universal V4.0 atualizado" {
    if (Test-Path "GRUPO-US-UNIVERSAL-AI-CONFIGURATION.md") {
        $content = Get-Content "GRUPO-US-UNIVERSAL-AI-CONFIGURATION.md" -Raw
        $content -match "V4\.0" -and $content -match "00-vibecode-system-v4-master\.md"
    } else { $false }
} "Configuration"

Test-Component "VS Code settings V4.0 configurado" {
    if (Test-Path ".vscode/settings.json") {
        $content = Get-Content ".vscode/settings.json" -Raw
        $content -match "VIBECODE SYSTEM V4\.0" -and $content -match "grupous\.vibecode\.version.*4\.0"
    } else { $false }
} "Configuration"

Test-Component "MCP configuration otimizada" {
    if (Test-Path "@project-core/configs/mcp-master-unified.json") {
        $content = Get-Content "@project-core/configs/mcp-master-unified.json" -Raw
        $content -match "sequential-thinking" -and $content -match "mcp-shrimp"
    } else { $false }
} "Configuration"

# ===== FASE 4: VALIDAÇÃO DA LIMPEZA DE REGRAS =====
Write-Host "`n🧹 FASE 4: VALIDAÇÃO DA LIMPEZA DE REGRAS" -ForegroundColor Magenta

Test-Component ".clinerules contém apenas caller" {
    if (Test-Path ".clinerules/rules") {
        $files = Get-ChildItem ".clinerules/rules" -File
        $files.Count -eq 1 -and $files[0].Name -eq "master_rule.md"
    } else { $false }
} "Cleanup"

Test-Component "Caller aponta para constituição V4.0" {
    if (Test-Path ".clinerules/rules/master_rule.md") {
        $content = Get-Content ".clinerules/rules/master_rule.md" -Raw
        $content -match "00-vibecode-system-v4-master\.md" -and $content -match "V4\.0"
    } else { $false }
} "Cleanup"

Test-Component "Backup das regras antigas criado" {
    $backupDirs = Get-ChildItem "@project-core/backups" -Directory | Where-Object { $_.Name -like "*clinerules-backup-v4*" }
    $backupDirs.Count -gt 0
} "Cleanup"

# ===== FASE 5: VALIDAÇÃO DE INTEGRIDADE GERAL =====
Write-Host "`n🔍 FASE 5: VALIDAÇÃO DE INTEGRIDADE GERAL" -ForegroundColor Magenta

Test-Component "Estrutura @project-core intacta" {
    (Test-Path "@project-core" -PathType Container) -and
    (Test-Path "@project-core/rules" -PathType Container) -and
    (Test-Path "@project-core/memory" -PathType Container) -and
    (Test-Path "@project-core/configs" -PathType Container)
} "Integrity"

Test-Component "Arquivos críticos preservados" {
    (Test-Path "@project-core/memory/self_correction_log.md") -and
    (Test-Path "@project-core/configs/mcp-master-unified.json") -and
    (Test-Path "GRUPO-US-UNIVERSAL-AI-CONFIGURATION.md")
} "Integrity"

Test-Component "Nenhum arquivo crítico corrompido" {
    try {
        Get-Content "@project-core/rules/00-vibecode-system-v4-master.md" -ErrorAction Stop | Out-Null
        Get-Content "@project-core/memory/self_correction_log.md" -ErrorAction Stop | Out-Null
        Get-Content "GRUPO-US-UNIVERSAL-AI-CONFIGURATION.md" -ErrorAction Stop | Out-Null
        $true
    } catch { $false }
} "Integrity"

# ===== RELATÓRIO FINAL =====
Write-Host "`n" + "=" * 60 -ForegroundColor Cyan
Write-Host "📊 RELATÓRIO FINAL - VIBECODE SYSTEM V4.0" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

$successRate = [math]::Round(($script:PassedTests / $script:TotalTests) * 100, 1)

Write-Host "Total de Testes: $($script:TotalTests)" -ForegroundColor White
Write-Host "Testes Aprovados: $($script:PassedTests)" -ForegroundColor Green
Write-Host "Testes Falharam: $($script:FailedTests)" -ForegroundColor Red
Write-Host "Taxa de Sucesso: $successRate%" -ForegroundColor $(if ($successRate -ge 90) { "Green" } elseif ($successRate -ge 80) { "Yellow" } else { "Red" })

if ($Detailed) {
    Write-Host "`n📋 DETALHES POR CATEGORIA:" -ForegroundColor Cyan
    $script:TestResults | Group-Object Category | ForEach-Object {
        Write-Host "`n$($_.Name):" -ForegroundColor Yellow
        $_.Group | ForEach-Object {
            $color = switch ($_.Status) {
                "PASS" { "Green" }
                "FAIL" { "Red" }
                "ERROR" { "Magenta" }
            }
            Write-Host "  $($_.Status): $($_.Test)" -ForegroundColor $color
        }
    }
}

# ===== CONCLUSÃO =====
Write-Host "`n" + "=" * 60 -ForegroundColor Cyan

if ($successRate -ge 95) {
    Write-Host "🎉 VIBECODE SYSTEM V4.0 - EVOLUÇÃO COMPLETA!" -ForegroundColor Green
    Write-Host "✅ Sistema totalmente operacional e otimizado" -ForegroundColor Green
    Write-Host "🚀 Pronto para produção com excelência máxima" -ForegroundColor Green
} elseif ($successRate -ge 85) {
    Write-Host "✅ VIBECODE SYSTEM V4.0 - EVOLUÇÃO BEM-SUCEDIDA!" -ForegroundColor Yellow
    Write-Host "⚠️ Alguns ajustes menores podem ser necessários" -ForegroundColor Yellow
    Write-Host "🔧 Sistema funcional com alta qualidade" -ForegroundColor Yellow
} else {
    Write-Host "⚠️ VIBECODE SYSTEM V4.0 - REQUER ATENÇÃO" -ForegroundColor Red
    Write-Host "❌ Problemas críticos identificados" -ForegroundColor Red
    Write-Host "🔧 Correções necessárias antes da produção" -ForegroundColor Red
}

Write-Host "`n🎯 GRUPO US VIBECODE SYSTEM V4.0 - Intelligence Through Evolution!" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

# Salvar relatório
$reportPath = "@project-core/memory/vibecode-v4-validation-report-$(Get-Date -Format 'yyyyMMdd_HHmmss').md"
$report = @"
# VIBECODE SYSTEM V4.0 - VALIDATION REPORT

**Data**: $(Get-Date)
**Taxa de Sucesso**: $successRate%
**Testes Totais**: $($script:TotalTests)
**Aprovados**: $($script:PassedTests)
**Falharam**: $($script:FailedTests)

## Resultados por Categoria

$($script:TestResults | Group-Object Category | ForEach-Object {
"### $($_.Name)
$($_.Group | ForEach-Object { "- [$($_.Status)] $($_.Test)" } | Out-String)"
} | Out-String)

## Status Final

$(if ($successRate -ge 95) {
"✅ **EVOLUÇÃO COMPLETA** - Sistema totalmente operacional"
} elseif ($successRate -ge 85) {
"✅ **EVOLUÇÃO BEM-SUCEDIDA** - Sistema funcional com alta qualidade"
} else {
"⚠️ **REQUER ATENÇÃO** - Correções necessárias"
})

---
**GRUPO US VIBECODE SYSTEM V4.0** - Intelligence Through Evolution!
"@

$report | Out-File -FilePath $reportPath -Encoding UTF8
Write-Host "📄 Relatório salvo em: $reportPath" -ForegroundColor Cyan
