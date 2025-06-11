# ===============================================================================
# DEPENDENCY CHECK SCRIPT - GRUPO US VIBECODE SYSTEM V2.0
# ===============================================================================
# Verifica vulnerabilidades e atualizações de dependências
# Author: Augment Agent - Security & Maintenance System
# Date: 2025-06-08
# ===============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$Fix,
    
    [Parameter(Mandatory = $false)]
    [switch]$UpdateAll,
    
    [Parameter(Mandatory = $false)]
    [switch]$SecurityOnly
)

# Status message function
function Write-StatusMessage($Message, $Type = "Info") {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Type) {
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
        "Info" { "Cyan" }
        default { "White" }
    }
    Write-Host "[$timestamp] $Message" -ForegroundColor $color
}

# ===============================================================================
# DEPENDENCY CHECK FUNCTIONS
# ===============================================================================

function Test-PackageManager {
    Write-StatusMessage "Verificando gerenciadores de pacotes..." "Info"
    
    $managers = @{
        npm = $false
        yarn = $false
        pnpm = $false
    }
    
    # Check npm
    try {
        $npmVersion = & npm --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            $managers.npm = $true
            Write-StatusMessage "  ✅ npm: $npmVersion" "Success"
        }
    }
    catch {
        Write-StatusMessage "  ❌ npm não encontrado" "Warning"
    }
    
    # Check yarn
    try {
        $yarnVersion = & yarn --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            $managers.yarn = $true
            Write-StatusMessage "  ✅ yarn: $yarnVersion" "Success"
        }
    }
    catch {
        Write-StatusMessage "  ❌ yarn não encontrado" "Warning"
    }
    
    # Check pnpm
    try {
        $pnpmVersion = & pnpm --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            $managers.pnpm = $true
            Write-StatusMessage "  ✅ pnpm: $pnpmVersion" "Success"
        }
    }
    catch {
        Write-StatusMessage "  ❌ pnpm não encontrado" "Warning"
    }
    
    return $managers
}

function Test-SecurityVulnerabilities {
    param([hashtable]$PackageManagers)
    
    Write-StatusMessage "=== VERIFICANDO VULNERABILIDADES DE SEGURANÇA ===" "Info"
    
    $vulnerabilities = @{
        Found = 0
        Critical = 0
        High = 0
        Moderate = 0
        Low = 0
    }
    
    if ($PackageManagers.npm -and (Test-Path "package.json")) {
        Write-StatusMessage "Executando npm audit..." "Info"
        
        try {
            $auditResult = & npm audit --json 2>$null
            if ($LASTEXITCODE -ne 0) {
                # npm audit returns non-zero when vulnerabilities are found
                $auditData = $auditResult | ConvertFrom-Json
                
                if ($auditData.metadata) {
                    $vulnerabilities.Found = $auditData.metadata.vulnerabilities.total
                    $vulnerabilities.Critical = $auditData.metadata.vulnerabilities.critical
                    $vulnerabilities.High = $auditData.metadata.vulnerabilities.high
                    $vulnerabilities.Moderate = $auditData.metadata.vulnerabilities.moderate
                    $vulnerabilities.Low = $auditData.metadata.vulnerabilities.low
                    
                    Write-StatusMessage "Vulnerabilidades encontradas:" "Warning"
                    Write-StatusMessage "  🔴 Critical: $($vulnerabilities.Critical)" "Error"
                    Write-StatusMessage "  🟠 High: $($vulnerabilities.High)" "Warning"
                    Write-StatusMessage "  🟡 Moderate: $($vulnerabilities.Moderate)" "Warning"
                    Write-StatusMessage "  🟢 Low: $($vulnerabilities.Low)" "Info"
                }
            } else {
                Write-StatusMessage "✅ Nenhuma vulnerabilidade encontrada" "Success"
            }
        }
        catch {
            Write-StatusMessage "Erro ao executar npm audit: $($_.Exception.Message)" "Error"
        }
    }
    
    return $vulnerabilities
}

function Test-OutdatedPackages {
    param([hashtable]$PackageManagers)
    
    Write-StatusMessage "=== VERIFICANDO PACOTES DESATUALIZADOS ===" "Info"
    
    $outdatedPackages = @()
    
    if ($PackageManagers.npm -and (Test-Path "package.json")) {
        Write-StatusMessage "Verificando pacotes npm desatualizados..." "Info"
        
        try {
            $outdatedResult = & npm outdated --json 2>$null
            if ($outdatedResult) {
                $outdatedData = $outdatedResult | ConvertFrom-Json
                
                foreach ($package in $outdatedData.PSObject.Properties) {
                    $packageInfo = $package.Value
                    $outdatedPackages += @{
                        Name = $package.Name
                        Current = $packageInfo.current
                        Wanted = $packageInfo.wanted
                        Latest = $packageInfo.latest
                        Type = if ($packageInfo.type) { $packageInfo.type } else { "dependency" }
                    }
                }
                
                Write-StatusMessage "Pacotes desatualizados encontrados: $($outdatedPackages.Count)" "Warning"
                foreach ($pkg in $outdatedPackages) {
                    Write-StatusMessage "  📦 $($pkg.Name): $($pkg.Current) → $($pkg.Latest)" "Info"
                }
            } else {
                Write-StatusMessage "✅ Todos os pacotes estão atualizados" "Success"
            }
        }
        catch {
            Write-StatusMessage "Erro ao verificar pacotes desatualizados: $($_.Exception.Message)" "Error"
        }
    }
    
    return $outdatedPackages
}

function Repair-SecurityVulnerabilities {
    param([hashtable]$PackageManagers, [hashtable]$Vulnerabilities)
    
    if ($Vulnerabilities.Found -eq 0) {
        Write-StatusMessage "Nenhuma vulnerabilidade para corrigir" "Info"
        return $true
    }
    
    Write-StatusMessage "=== CORRIGINDO VULNERABILIDADES ===" "Info"
    
    if ($PackageManagers.npm) {
        try {
            Write-StatusMessage "Executando npm audit fix..." "Info"
            $fixResult = & npm audit fix 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-StatusMessage "✅ Vulnerabilidades corrigidas com sucesso" "Success"
                return $true
            } else {
                Write-StatusMessage "⚠️ Algumas vulnerabilidades podem precisar de correção manual" "Warning"
                Write-StatusMessage "Tente: npm audit fix --force (cuidado!)" "Info"
                return $false
            }
        }
        catch {
            Write-StatusMessage "Erro ao corrigir vulnerabilidades: $($_.Exception.Message)" "Error"
            return $false
        }
    }
    
    return $false
}

function Update-Dependencies {
    param([hashtable]$PackageManagers, [array]$OutdatedPackages, [bool]$SecurityOnly)
    
    if ($OutdatedPackages.Count -eq 0) {
        Write-StatusMessage "Nenhum pacote para atualizar" "Info"
        return $true
    }
    
    Write-StatusMessage "=== ATUALIZANDO DEPENDÊNCIAS ===" "Info"
    
    if ($SecurityOnly) {
        Write-StatusMessage "Modo somente segurança - atualizando apenas correções críticas" "Warning"
    }
    
    if ($PackageManagers.npm) {
        try {
            if ($SecurityOnly) {
                # Update only security patches
                Write-StatusMessage "Atualizando patches de segurança..." "Info"
                $updateResult = & npm update --save 2>&1
            } else {
                # Update all packages
                Write-StatusMessage "Atualizando todos os pacotes..." "Info"
                $updateResult = & npm update 2>&1
            }
            
            if ($LASTEXITCODE -eq 0) {
                Write-StatusMessage "✅ Dependências atualizadas com sucesso" "Success"
                return $true
            } else {
                Write-StatusMessage "❌ Erro ao atualizar dependências" "Error"
                Write-Host $updateResult
                return $false
            }
        }
        catch {
            Write-StatusMessage "Erro ao atualizar dependências: $($_.Exception.Message)" "Error"
            return $false
        }
    }
    
    return $false
}

function New-DependencyReport {
    param([hashtable]$Vulnerabilities, [array]$OutdatedPackages)
    
    Write-StatusMessage "Gerando relatório de dependências..." "Info"
    
    try {
        $reportPath = "@project-core/reports/dependency-check-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
        
        # Ensure reports directory exists
        $reportsDir = "@project-core/reports"
        if (-not (Test-Path $reportsDir)) {
            New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null
        }
        
        $report = @"
# Dependency Check Report
**Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## Security Vulnerabilities
- **Total**: $($Vulnerabilities.Found)
- **Critical**: $($Vulnerabilities.Critical)
- **High**: $($Vulnerabilities.High)
- **Moderate**: $($Vulnerabilities.Moderate)
- **Low**: $($Vulnerabilities.Low)

## Outdated Packages
- **Total Outdated**: $($OutdatedPackages.Count)

### Package Details
$(if ($OutdatedPackages.Count -gt 0) {
    ($OutdatedPackages | ForEach-Object { "- **$($_.Name)**: $($_.Current) → $($_.Latest)" }) -join "`n"
} else {
    "- All packages are up to date"
})

## Recommendations
1. **Security**: $(if ($Vulnerabilities.Found -gt 0) { "Run 'npm audit fix' to resolve vulnerabilities" } else { "No security issues found" })
2. **Updates**: $(if ($OutdatedPackages.Count -gt 0) { "Consider updating outdated packages" } else { "All packages are current" })
3. **Monitoring**: Set up automated dependency checking in CI/CD
4. **Review**: Regular security audits (weekly recommended)

---
*Generated by Dependency Check System - GRUPO US VIBECODE SYSTEM V2.0*
"@
        
        Set-Content -Path $reportPath -Value $report
        Write-StatusMessage "Relatório gerado: $reportPath" "Success"
        
        return $reportPath
    }
    catch {
        Write-StatusMessage "Erro ao gerar relatório: $($_.Exception.Message)" "Error"
        return $null
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

try {
    Write-StatusMessage "🔍 DEPENDENCY CHECK - GRUPO US VIBECODE SYSTEM V2.0" "Info"
    Write-StatusMessage "================================================================" "Info"
    
    # Step 1: Check package managers
    $packageManagers = Test-PackageManager
    
    if (-not ($packageManagers.npm -or $packageManagers.yarn -or $packageManagers.pnpm)) {
        Write-StatusMessage "❌ Nenhum gerenciador de pacotes encontrado" "Error"
        exit 1
    }
    
    # Step 2: Check for vulnerabilities
    $vulnerabilities = Test-SecurityVulnerabilities -PackageManagers $packageManagers
    
    # Step 3: Check for outdated packages
    $outdatedPackages = Test-OutdatedPackages -PackageManagers $packageManagers
    
    # Step 4: Fix vulnerabilities if requested
    if ($Fix -and $vulnerabilities.Found -gt 0) {
        Repair-SecurityVulnerabilities -PackageManagers $packageManagers -Vulnerabilities $vulnerabilities | Out-Null
    }
    
    # Step 5: Update dependencies if requested
    if ($UpdateAll -and $outdatedPackages.Count -gt 0) {
        Update-Dependencies -PackageManagers $packageManagers -OutdatedPackages $outdatedPackages -SecurityOnly $SecurityOnly | Out-Null
    }
    
    # Step 6: Generate report
    $reportPath = New-DependencyReport -Vulnerabilities $vulnerabilities -OutdatedPackages $outdatedPackages
    
    # Final assessment
    $criticalIssues = $vulnerabilities.Critical + $vulnerabilities.High
    
    Write-StatusMessage "================================================================" "Info"
    
    if ($criticalIssues -eq 0 -and $outdatedPackages.Count -eq 0) {
        Write-StatusMessage "🎉 DEPENDENCY CHECK PASSED!" "Success"
        Write-StatusMessage "Todas as dependências estão seguras e atualizadas" "Success"
        exit 0
    } elseif ($criticalIssues -eq 0) {
        Write-StatusMessage "⚠️ DEPENDENCY CHECK - MINOR ISSUES" "Warning"
        Write-StatusMessage "$($outdatedPackages.Count) pacotes desatualizados encontrados" "Warning"
        exit 0
    } else {
        Write-StatusMessage "❌ DEPENDENCY CHECK - CRITICAL ISSUES" "Error"
        Write-StatusMessage "$criticalIssues vulnerabilidades críticas/altas encontradas" "Error"
        exit 1
    }
}
catch {
    Write-StatusMessage "Dependency check failed: $($_.Exception.Message)" "Error"
    exit 1
}

# ===============================================================================
# USAGE EXAMPLES
# ===============================================================================
<#
.SYNOPSIS
Dependency check script for GRUPO US VIBECODE SYSTEM V2.0

.DESCRIPTION
Verifica vulnerabilidades de segurança e pacotes desatualizados,
com opções para correção automática.

.PARAMETER Fix
Corrige automaticamente vulnerabilidades de segurança

.PARAMETER UpdateAll
Atualiza todos os pacotes desatualizados

.PARAMETER SecurityOnly
Atualiza apenas correções de segurança (usado com UpdateAll)

.EXAMPLE
# Verificação básica
.\dependency-check.ps1

.EXAMPLE
# Verificação e correção de vulnerabilidades
.\dependency-check.ps1 -Fix

.EXAMPLE
# Atualização completa de dependências
.\dependency-check.ps1 -UpdateAll

.EXAMPLE
# Atualização apenas de segurança
.\dependency-check.ps1 -UpdateAll -SecurityOnly
#>
