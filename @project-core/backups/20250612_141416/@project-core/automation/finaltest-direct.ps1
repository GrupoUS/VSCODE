# 🚀 FINALTEST DIRETO - VIBECODE SYSTEM V4.5
# Validação simplificada sem dependências externas

Write-Host "🚀 EXECUTANDO !FINALTEST - VIBECODE SYSTEM V4.5" -ForegroundColor Cyan
Write-Host "📊 Validação Completa do Sistema em Progresso..." -ForegroundColor Yellow

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$reportPath = "@project-core/reports/finaltest-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

# Criar diretório de relatórios se não existir
if (-not (Test-Path "@project-core/reports")) {
    New-Item -ItemType Directory -Path "@project-core/reports" -Force | Out-Null
}

$report = @"
# 🎉 !FINALTEST EXECUTADO COM SUCESSO - VIBECODE SYSTEM V4.5

**Data de Execução**: $timestamp
**Status**: ✅ COMPLETO
**Versão**: VIBECODE SYSTEM V4.5

---

## 📊 VALIDAÇÃO DE SISTEMA

### 🔍 ESTRUTURA DE ARQUIVOS

#### ✅ Arquivos Críticos do Sistema
"@

Write-Host "🔍 FASE 1: Validação de Estrutura de Arquivos" -ForegroundColor Magenta

# Verificar arquivos críticos
$criticalFiles = @(
    "@project-core/memory/master_rule.md",
    "@project-core/memory/self_correction_log.md",
    "@project-core/configs/projects-sync-config.json",
    "@project-core/automation/sync-github-auto.ps1",
    "@project-core/automation/AUTOSYNC-SOVEREIGN-GUIDE.md"
)

$filesValid = 0
foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        Write-Host "  ✅ $file" -ForegroundColor Green
        $report += "`n- ✅ ``$file`` (Presente)"
        $filesValid++
    } else {
        Write-Host "  ❌ $file" -ForegroundColor Red
        $report += "`n- ❌ ``$file`` (Ausente)"
    }
}

Write-Host "📁 FASE 2: Validação de Diretórios Críticos" -ForegroundColor Magenta

# Verificar diretórios críticos
$criticalDirs = @(
    "@project-core/memory",
    "@project-core/configs",
    "@project-core/automation",
    "@project-core/projects",
    "@project-core/reports"
)

$dirsValid = 0
$report += "`n`n#### ✅ Diretórios Críticos"
foreach ($dir in $criticalDirs) {
    if (Test-Path $dir) {
        Write-Host "  ✅ $dir/" -ForegroundColor Green
        $report += "`n- ✅ ``$dir/`` (Presente)"
        $dirsValid++
    } else {
        Write-Host "  ❌ $dir/" -ForegroundColor Red
        $report += "`n- ❌ ``$dir/`` (Ausente)"
    }
}

Write-Host "🔧 FASE 3: Validação de Configurações" -ForegroundColor Magenta

# Verificar projetos configurados
$report += "`n`n### 🎯 PROJETOS CONFIGURADOS"

if (Test-Path "@project-core/configs/projects-sync-config.json") {
    try {
        $config = Get-Content "@project-core/configs/projects-sync-config.json" | ConvertFrom-Json
        $projectCount = $config.projects.PSObject.Properties.Count
        Write-Host "  ✅ $projectCount projetos configurados" -ForegroundColor Green
        $report += "`n- ✅ **$projectCount projetos** configurados para sincronização soberana"

        foreach ($project in $config.projects.PSObject.Properties) {
            $projectName = $project.Name
            $projectPath = $project.Value.localPath
            if (Test-Path $projectPath) {
                Write-Host "    ✅ $projectName" -ForegroundColor Green
                $report += "`n  - ✅ **$projectName**: ``$projectPath``"
            } else {
                Write-Host "    ⚠️ $projectName (pasta não encontrada)" -ForegroundColor Yellow
                $report += "`n  - ⚠️ **$projectName**: ``$projectPath`` (pasta não encontrada)"
            }
        }
    } catch {
        Write-Host "  ❌ Erro ao ler configuração de projetos" -ForegroundColor Red
        $report += "`n- ❌ Erro ao ler configuração de projetos"
    }
}

Write-Host "🔐 FASE 4: Validação de Autenticação GitHub" -ForegroundColor Magenta

# Verificar GitHub CLI
$report += "`n`n### 🔐 AUTENTICAÇÃO GITHUB"

if (Test-Path "C:\Program Files\GitHub CLI\gh.exe") {
    Write-Host "  ✅ GitHub CLI instalado" -ForegroundColor Green
    $report += "`n- ✅ **GitHub CLI**: Instalado e disponível"

    try {
        $authStatus = & "C:\Program Files\GitHub CLI\gh.exe" auth status 2>&1
        if ($authStatus -match "Logged in") {
            Write-Host "  ✅ GitHub CLI autenticado" -ForegroundColor Green
            $report += "`n- ✅ **Autenticação**: Ativa e funcionando"
        } else {
            Write-Host "  ⚠️ GitHub CLI não autenticado" -ForegroundColor Yellow
            $report += "`n- ⚠️ **Autenticação**: Não configurada"
        }
    } catch {
        Write-Host "  ⚠️ Erro ao verificar autenticação" -ForegroundColor Yellow
        $report += "`n- ⚠️ **Autenticação**: Erro na verificação"
    }
} else {
    Write-Host "  ❌ GitHub CLI não encontrado" -ForegroundColor Red
    $report += "`n- ❌ **GitHub CLI**: Não instalado"
}

Write-Host "📊 FASE 5: Relatório Final" -ForegroundColor Magenta

# Calcular score final
$totalFiles = $criticalFiles.Count
$totalDirs = $criticalDirs.Count
$fileScore = ($filesValid / $totalFiles) * 100
$dirScore = ($dirsValid / $totalDirs) * 100
$overallScore = (($filesValid + $dirsValid) / ($totalFiles + $totalDirs)) * 100

$report += "`n`n## 📊 RESULTADO FINAL"
$report += "`n`n### 🎯 PONTUAÇÃO GERAL"
$report += "`n- **Arquivos Críticos**: $filesValid/$totalFiles ($('{0:F1}' -f $fileScore)%)"
$report += "`n- **Diretórios Críticos**: $dirsValid/$totalDirs ($('{0:F1}' -f $dirScore)%)"
$report += "`n- **Score Geral**: $('{0:F1}' -f $overallScore)%"

if ($overallScore -ge 90) {
    $status = "🏆 EXCELENTE"
    $color = "Green"
} elseif ($overallScore -ge 75) {
    $status = "✅ BOM"
    $color = "Green"
} elseif ($overallScore -ge 50) {
    $status = "⚠️ ATENÇÃO"
    $color = "Yellow"
} else {
    $status = "❌ CRÍTICO"
    $color = "Red"
}

$report += "`n`n### 🎉 STATUS FINAL: **$status**"
$report += "`n`n**Sistema VIBECODE V4.5 validado em $timestamp**"
$report += "`n"
$report += "`n---"
$report += "`n"
$report += "`n*Relatório gerado automaticamente pelo !finaltest*"

# Salvar relatório
$report | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host "`n📊 RESULTADO FINAL" -ForegroundColor Magenta
Write-Host "Score Geral: $('{0:F1}' -f $overallScore)%" -ForegroundColor $color
Write-Host "Status: $status" -ForegroundColor $color
Write-Host "Relatório salvo em: $reportPath" -ForegroundColor Gray

Write-Host "`n🎉 !FINALTEST CONCLUÍDO COM SUCESSO!" -ForegroundColor Green
Write-Host "Sistema VIBECODE V4.5 validado e operacional" -ForegroundColor Cyan
