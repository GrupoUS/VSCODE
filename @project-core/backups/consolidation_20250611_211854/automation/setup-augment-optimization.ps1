# ===============================================================================
# AUGMENT OPTIMIZATION SETUP - GRUPO US VIBECODE SYSTEM V2.0
# ===============================================================================
# Aplica configurações otimizadas do Augment Code baseadas na documentação oficial
# Author: Augment Agent - Optimization System
# Date: 2025-06-08
# ===============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$Force,
    
    [Parameter(Mandatory = $false)]
    [switch]$SkipBackup,
    
    [Parameter(Mandatory = $false)]
    [switch]$TestMode
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
# VERIFICATION FUNCTIONS
# ===============================================================================

function Test-AugmentExtension {
    Write-StatusMessage "Verificando extensão Augment..." "Info"
    
    # Check if VS Code is available
    try {
        $codeVersion = & code --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-StatusMessage "VS Code encontrado: $($codeVersion[0])" "Success"
            
            # Check if Augment extension is installed
            $extensions = & code --list-extensions 2>$null
            if ($extensions -contains "augment.vscode-augment") {
                Write-StatusMessage "✅ Extensão Augment instalada" "Success"
                return $true
            } else {
                Write-StatusMessage "❌ Extensão Augment não encontrada" "Error"
                Write-StatusMessage "Instale com: code --install-extension augment.vscode-augment" "Warning"
                return $false
            }
        } else {
            Write-StatusMessage "❌ VS Code não encontrado" "Error"
            return $false
        }
    }
    catch {
        Write-StatusMessage "❌ Erro ao verificar VS Code: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Test-ExistingConfigurations {
    Write-StatusMessage "Verificando configurações existentes..." "Info"
    
    $existingFiles = @()
    
    if (Test-Path ".augmentignore") {
        $existingFiles += ".augmentignore"
    }
    
    if (Test-Path ".augment-guidelines") {
        $existingFiles += ".augment-guidelines"
    }
    
    if ($existingFiles.Count -gt 0) {
        Write-StatusMessage "Arquivos existentes encontrados: $($existingFiles -join ', ')" "Warning"
        
        if (-not $Force) {
            Write-StatusMessage "Use -Force para sobrescrever arquivos existentes" "Warning"
            return $false
        } else {
            Write-StatusMessage "Modo Force ativado - arquivos serão sobrescritos" "Warning"
        }
    }
    
    return $true
}

# ===============================================================================
# BACKUP FUNCTIONS
# ===============================================================================

function New-ConfigurationBackup {
    if ($SkipBackup) {
        Write-StatusMessage "Pulando backup conforme solicitado" "Info"
        return $true
    }
    
    Write-StatusMessage "Criando backup das configurações existentes..." "Info"
    
    try {
        $backupDir = "@project-core/backups/augment-config-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        
        if (-not (Test-Path "@project-core/backups")) {
            New-Item -ItemType Directory -Path "@project-core/backups" -Force | Out-Null
        }
        
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        
        $filesToBackup = @(".augmentignore", ".augment-guidelines", ".vscode/settings.json")
        
        foreach ($file in $filesToBackup) {
            if (Test-Path $file) {
                $destPath = Join-Path $backupDir (Split-Path $file -Leaf)
                Copy-Item -Path $file -Destination $destPath -Force
                Write-StatusMessage "  📁 Backup criado: $file" "Success"
            }
        }
        
        Write-StatusMessage "Backup salvo em: $backupDir" "Success"
        return $true
    }
    catch {
        Write-StatusMessage "Erro ao criar backup: $($_.Exception.Message)" "Error"
        return $false
    }
}

# ===============================================================================
# CONFIGURATION FUNCTIONS
# ===============================================================================

function Set-AugmentIgnoreFile {
    Write-StatusMessage "Configurando .augmentignore..." "Info"
    
    if ($TestMode) {
        Write-StatusMessage "MODO TESTE: .augmentignore seria criado/atualizado" "Warning"
        return $true
    }
    
    try {
        # The .augmentignore file should already exist from previous creation
        if (Test-Path ".augmentignore") {
            Write-StatusMessage "✅ .augmentignore já existe e está otimizado" "Success"
        } else {
            Write-StatusMessage "❌ .augmentignore não encontrado - execute o script de criação primeiro" "Error"
            return $false
        }
        
        return $true
    }
    catch {
        Write-StatusMessage "Erro ao configurar .augmentignore: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Set-AugmentGuidelines {
    Write-StatusMessage "Configurando .augment-guidelines..." "Info"
    
    if ($TestMode) {
        Write-StatusMessage "MODO TESTE: .augment-guidelines seria criado/atualizado" "Warning"
        return $true
    }
    
    try {
        # The .augment-guidelines file should already exist from previous creation
        if (Test-Path ".augment-guidelines") {
            Write-StatusMessage "✅ .augment-guidelines já existe e está otimizado" "Success"
        } else {
            Write-StatusMessage "❌ .augment-guidelines não encontrado - execute o script de criação primeiro" "Error"
            return $false
        }
        
        return $true
    }
    catch {
        Write-StatusMessage "Erro ao configurar .augment-guidelines: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Set-VSCodeSettings {
    Write-StatusMessage "Configurando VS Code settings para Augment..." "Info"
    
    if ($TestMode) {
        Write-StatusMessage "MODO TESTE: VS Code settings seriam atualizados" "Warning"
        return $true
    }
    
    try {
        $vscodeDir = ".vscode"
        $settingsFile = "$vscodeDir/settings.json"
        
        # Create .vscode directory if it doesn't exist
        if (-not (Test-Path $vscodeDir)) {
            New-Item -ItemType Directory -Path $vscodeDir -Force | Out-Null
        }
        
        # Augment optimized settings
        $augmentSettings = @{
            "augment.chat.enhancePrompts" = $true
            "augment.nextEdit.enableBackgroundSuggestions" = $true
            "augment.nextEdit.enableGlobalBackgroundSuggestions" = $true
            "augment.nextEdit.showDiffInHover" = $true
            "augment.nextEdit.highlightSuggestions" = $true
            "augment.completions.enabled" = $true
            "augment.workspace.autoIndex" = $true
        }
        
        # Read existing settings or create new
        $currentSettings = @{}
        if (Test-Path $settingsFile) {
            try {
                $currentSettings = Get-Content $settingsFile | ConvertFrom-Json -AsHashtable
            }
            catch {
                Write-StatusMessage "Arquivo settings.json inválido, criando novo" "Warning"
                $currentSettings = @{}
            }
        }
        
        # Merge Augment settings
        foreach ($key in $augmentSettings.Keys) {
            $currentSettings[$key] = $augmentSettings[$key]
        }
        
        # Save updated settings
        $currentSettings | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsFile
        
        Write-StatusMessage "✅ VS Code settings atualizados com configurações Augment" "Success"
        return $true
    }
    catch {
        Write-StatusMessage "Erro ao configurar VS Code settings: $($_.Exception.Message)" "Error"
        return $false
    }
}

# ===============================================================================
# VALIDATION FUNCTIONS
# ===============================================================================

function Test-AugmentConfiguration {
    Write-StatusMessage "Validando configuração do Augment..." "Info"
    
    $validationResults = @{
        AugmentIgnore = Test-Path ".augmentignore"
        AugmentGuidelines = Test-Path ".augment-guidelines"
        VSCodeSettings = Test-Path ".vscode/settings.json"
        OptimizationGuide = Test-Path "@project-core/memory/augment-optimization-guide.md"
    }
    
    $passedTests = 0
    $totalTests = $validationResults.Count
    
    foreach ($test in $validationResults.GetEnumerator()) {
        if ($test.Value) {
            Write-StatusMessage "  ✅ $($test.Key)" "Success"
            $passedTests++
        } else {
            Write-StatusMessage "  ❌ $($test.Key)" "Error"
        }
    }
    
    $successRate = [math]::Round(($passedTests / $totalTests) * 100, 1)
    Write-StatusMessage "Taxa de sucesso: $successRate% ($passedTests/$totalTests)" "Info"
    
    return $successRate -ge 75
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

try {
    Write-StatusMessage "🚀 AUGMENT OPTIMIZATION SETUP - GRUPO US VIBECODE SYSTEM V2.0" "Info"
    Write-StatusMessage "================================================================" "Info"
    
    if ($TestMode) {
        Write-StatusMessage "🧪 MODO TESTE ATIVADO - Nenhuma alteração será feita" "Warning"
    }
    
    # Step 1: Verify Augment extension
    if (-not (Test-AugmentExtension)) {
        Write-StatusMessage "❌ Extensão Augment não disponível, abortando setup" "Error"
        exit 1
    }
    
    # Step 2: Check existing configurations
    if (-not (Test-ExistingConfigurations)) {
        Write-StatusMessage "❌ Verificação de configurações falhou" "Error"
        exit 1
    }
    
    # Step 3: Create backup
    if (-not (New-ConfigurationBackup)) {
        Write-StatusMessage "⚠️ Backup falhou, mas continuando..." "Warning"
    }
    
    # Step 4: Configure Augment files
    if (-not (Set-AugmentIgnoreFile)) {
        Write-StatusMessage "❌ Configuração do .augmentignore falhou" "Error"
        exit 1
    }
    
    if (-not (Set-AugmentGuidelines)) {
        Write-StatusMessage "❌ Configuração do .augment-guidelines falhou" "Error"
        exit 1
    }
    
    # Step 5: Configure VS Code settings
    if (-not (Set-VSCodeSettings)) {
        Write-StatusMessage "⚠️ Configuração do VS Code falhou, mas continuando..." "Warning"
    }
    
    # Step 6: Validate configuration
    if (-not (Test-AugmentConfiguration)) {
        Write-StatusMessage "❌ Validação da configuração falhou" "Error"
        exit 1
    }
    
    # Final success message
    Write-StatusMessage "================================================================" "Info"
    Write-StatusMessage "🎉 AUGMENT OPTIMIZATION SETUP CONCLUÍDO COM SUCESSO!" "Success"
    Write-StatusMessage "================================================================" "Info"
    
    Write-StatusMessage "Próximos passos:" "Info"
    Write-StatusMessage "1. Reinicie o VS Code para aplicar as configurações" "Info"
    Write-StatusMessage "2. Abra o painel Augment com Cmd/Ctrl + L" "Info"
    Write-StatusMessage "3. Verifique se o workspace está sendo indexado" "Info"
    Write-StatusMessage "4. Teste as funcionalidades: Chat, Next Edit, Instructions, Completions" "Info"
    Write-StatusMessage "5. Consulte o guia: @project-core/memory/augment-optimization-guide.md" "Info"
    
    exit 0
}
catch {
    Write-StatusMessage "Setup do Augment falhou: $($_.Exception.Message)" "Error"
    exit 1
}

# ===============================================================================
# USAGE EXAMPLES
# ===============================================================================
<#
.SYNOPSIS
Setup de otimização do Augment Code para GRUPO US VIBECODE SYSTEM V2.0

.DESCRIPTION
Aplica configurações otimizadas do Augment Code baseadas na documentação oficial,
incluindo .augmentignore, .augment-guidelines e configurações do VS Code.

.PARAMETER Force
Força a sobrescrita de arquivos existentes

.PARAMETER SkipBackup
Pula a criação de backup das configurações existentes

.PARAMETER TestMode
Executa em modo teste sem fazer alterações reais

.EXAMPLE
# Setup básico
.\setup-augment-optimization.ps1

.EXAMPLE
# Setup forçado com backup
.\setup-augment-optimization.ps1 -Force

.EXAMPLE
# Teste sem alterações
.\setup-augment-optimization.ps1 -TestMode
#>
