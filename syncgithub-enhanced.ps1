# VIBECODE SYSTEM V4.0 - Sincronizacao Multi-Projetos GitHub (Versao Melhorada)
# Script melhorado com logging basico, validacao de seguranca e backup

param(
    [switch]$Force,
    [switch]$DryRun,
    [string]$ProjectName = "",
    [switch]$All,
    [string]$Message = "",
    [switch]$SkipSecurity,
    [switch]$SkipBackup,
    [switch]$Verbose
)

# Configuracoes base
$SystemRootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"
$LogPath = "@project-core\logs\sync-operations.log"

# Funcao de logging simples
function Write-SyncLog {
    param(
        [string]$Message,
        [string]$Level = "INFO",
        [string]$Project = "SYSTEM"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$timestamp] [$Level] [$Project] $Message"
    
    # Garantir que o diretorio de logs existe
    $fullLogPath = Join-Path $SystemRootPath $LogPath
    $logDir = Split-Path $fullLogPath -Parent
    
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    
    # Escrever no arquivo de log
    Add-Content -Path $fullLogPath -Value $logLine -Encoding UTF8
    
    # Exibir no console com cores
    $color = switch ($Level) {
        "DEBUG" { "Gray" }
        "INFO" { "White" }
        "WARNING" { "Yellow" }
        "ERROR" { "Red" }
        "CRITICAL" { "Magenta" }
        default { "White" }
    }
    
    Write-Host $logLine -ForegroundColor $color
}

# Funcao de validacao de seguranca basica
function Test-BasicSecurity {
    param(
        [string]$ProjectPath,
        [string]$ProjectName
    )
    
    Write-SyncLog "Iniciando validacao de seguranca basica" "INFO" $ProjectName
    
    $violations = @()
    
    try {
        # Verificar arquivos .env
        $envFiles = Get-ChildItem $ProjectPath -Filter "*.env*" -Recurse | Where-Object { 
            $_.Name -notmatch "\.example$|\.template$|\.sample$" 
        }
        
        foreach ($envFile in $envFiles) {
            $violations += "Arquivo .env detectado: $($envFile.Name)"
            Write-SyncLog "Arquivo .env detectado: $($envFile.Name)" "WARNING" $ProjectName
        }
        
        # Verificar node_modules no git
        $gitignorePath = Join-Path $ProjectPath ".gitignore"
        $nodeModulesPath = Join-Path $ProjectPath "node_modules"
        
        if ((Test-Path $nodeModulesPath) -and (Test-Path $gitignorePath)) {
            $gitignoreContent = Get-Content $gitignorePath -Raw
            if ($gitignoreContent -notmatch "node_modules") {
                $violations += "node_modules nao esta no .gitignore"
                Write-SyncLog "node_modules nao esta no .gitignore" "WARNING" $ProjectName
            }
        }
        
        $isCompliant = ($violations.Count -eq 0)
        
        if ($isCompliant) {
            Write-SyncLog "Validacao de seguranca aprovada" "INFO" $ProjectName
        } else {
            Write-SyncLog "Validacao de seguranca falhou: $($violations.Count) violacoes" "ERROR" $ProjectName
        }
        
        return @{
            Compliant = $isCompliant
            Violations = $violations
        }
        
    }
    catch {
        Write-SyncLog "Erro na validacao de seguranca: $($_.Exception.Message)" "ERROR" $ProjectName
        return @{
            Compliant = $false
            Error = $_.Exception.Message
        }
    }
}

# Funcao de backup basico
function New-BasicBackup {
    param(
        [string]$ProjectPath,
        [string]$ProjectName
    )
    
    Write-SyncLog "Iniciando backup basico" "INFO" $ProjectName
    
    try {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupName = "$ProjectName`_BACKUP_$timestamp"
        $backupPath = Join-Path $SystemRootPath "@project-core\backups\$backupName"
        
        # Criar diretorio de backup
        if (-not (Test-Path (Split-Path $backupPath -Parent))) {
            New-Item -ItemType Directory -Path (Split-Path $backupPath -Parent) -Force | Out-Null
        }
        
        # Copiar arquivos importantes (excluir node_modules, .next, etc.)
        $excludePatterns = @("node_modules", ".next", "dist", "build", "*.log", "*.tmp")
        
        robocopy $ProjectPath $backupPath /E /XD node_modules .next dist build /XF *.log *.tmp /NFL /NDL /NJH /NJS
        
        if (Test-Path $backupPath) {
            Write-SyncLog "Backup criado com sucesso: $backupName" "INFO" $ProjectName
            return @{
                Success = $true
                BackupName = $backupName
                BackupPath = $backupPath
            }
        } else {
            Write-SyncLog "Falha ao criar backup" "ERROR" $ProjectName
            return @{
                Success = $false
                Error = "Backup nao foi criado"
            }
        }
        
    }
    catch {
        Write-SyncLog "Erro no backup: $($_.Exception.Message)" "ERROR" $ProjectName
        return @{
            Success = $false
            Error = $_.Exception.Message
        }
    }
}

Write-Host "VIBECODE SYSTEM V4.0 - Sincronizacao Multi-Projetos (MELHORADA)" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

Write-SyncLog "Iniciando sistema de sincronizacao melhorado" "INFO" "SYSTEM"

# Configuracao dos projetos
$projects = @{
    "neonpro" = @{
        name = "NeonPro"
        localPath = "@project-core\projects\neonpro"
        repositoryUrl = "https://github.com/GrupoUS/neonpro.git"
        branch = "main"
    }
    "aegiswallet" = @{
        name = "AegisWallet"
        localPath = "@project-core\projects\aegiswallet"
        repositoryUrl = "https://github.com/GrupoUS/aegiswallet.git"
        branch = "main"
    }
    "agendatrintae3" = @{
        name = "AgendaTrintaE3"
        localPath = "@project-core\projects\agendatrintae3"
        repositoryUrl = "https://github.com/GrupoUS/agendatrintae3.git"
        branch = "main"
    }
}

# Funcao melhorada para sincronizar um projeto
function Sync-ProjectEnhanced {
    param(
        [hashtable]$ProjectConfig,
        [string]$ProjectKey
    )
    
    Write-SyncLog "Iniciando sincronizacao melhorada" "INFO" $ProjectConfig.name
    
    $projectPath = Join-Path $SystemRootPath $ProjectConfig.localPath
    $originalLocation = Get-Location
    $syncResult = @{
        Success = $false
        Project = $ProjectKey
        Name = $ProjectConfig.name
        Steps = @()
        Backup = $null
        SecurityCheck = $null
    }
    
    try {
        # Passo 1: Validacao inicial
        if ($Verbose) { Write-Host "Passo 1: Validacao inicial" -ForegroundColor Yellow }
        Write-SyncLog "Validacao inicial" "INFO" $ProjectConfig.name
        
        if (-not (Test-Path $projectPath)) {
            Write-SyncLog "Projeto nao encontrado: $projectPath" "ERROR" $ProjectConfig.name
            $syncResult.Steps += "VALIDATION: FAILED - Projeto nao encontrado"
            return $syncResult
        }
        
        Set-Location $projectPath
        $syncResult.Steps += "VALIDATION: SUCCESS"
        
        # Passo 2: Configuracao do Git
        if ($Verbose) { Write-Host "Passo 2: Configuracao do Git" -ForegroundColor Yellow }
        Write-SyncLog "Configuracao do Git" "INFO" $ProjectConfig.name
        
        if (-not (Test-Path ".git")) {
            Write-SyncLog "Inicializando repositorio Git" "INFO" $ProjectConfig.name
            git init
            git remote add origin $ProjectConfig.repositoryUrl
        }
        
        $currentRemote = git remote get-url origin 2>$null
        if ($currentRemote -ne $ProjectConfig.repositoryUrl) {
            Write-SyncLog "Atualizando remote URL" "INFO" $ProjectConfig.name
            git remote set-url origin $ProjectConfig.repositoryUrl
        }
        
        $syncResult.Steps += "GIT_SETUP: SUCCESS"
        
        # Passo 3: Verificacao de mudancas
        if ($Verbose) { Write-Host "Passo 3: Verificacao de mudancas" -ForegroundColor Yellow }
        Write-SyncLog "Verificacao de mudancas" "INFO" $ProjectConfig.name
        
        $gitStatus = git status --porcelain
        if (-not $gitStatus) {
            Write-SyncLog "Nenhuma mudanca detectada" "INFO" $ProjectConfig.name
            $syncResult.Success = $true
            $syncResult.Steps += "CHANGES_CHECK: NO_CHANGES"
            return $syncResult
        }
        
        Write-SyncLog "Mudancas detectadas: $($gitStatus.Count) arquivos" "INFO" $ProjectConfig.name
        $syncResult.Steps += "CHANGES_CHECK: $($gitStatus.Count) arquivos"
        
        if ($DryRun) {
            Write-SyncLog "DRY RUN - Simulacao concluida" "INFO" $ProjectConfig.name
            $syncResult.Success = $true
            $syncResult.Steps += "DRY_RUN: SUCCESS"
            return $syncResult
        }
        
        # Passo 4: Validacao de seguranca
        if (-not $SkipSecurity) {
            if ($Verbose) { Write-Host "Passo 4: Validacao de seguranca" -ForegroundColor Yellow }
            
            $securityResult = Test-BasicSecurity -ProjectPath $projectPath -ProjectName $ProjectConfig.name
            $syncResult.SecurityCheck = $securityResult
            
            if (-not $securityResult.Compliant) {
                Write-SyncLog "Validacao de seguranca falhou" "WARNING" $ProjectConfig.name
                $syncResult.Steps += "SECURITY: WARNING - $($securityResult.Violations.Count) violacoes"
                # Continuar mesmo com avisos de seguranca
            } else {
                $syncResult.Steps += "SECURITY: SUCCESS"
            }
        } else {
            Write-SyncLog "Validacao de seguranca ignorada" "WARNING" $ProjectConfig.name
            $syncResult.Steps += "SECURITY: SKIPPED"
        }
        
        # Passo 5: Backup automatico
        if (-not $SkipBackup) {
            if ($Verbose) { Write-Host "Passo 5: Backup automatico" -ForegroundColor Yellow }
            
            $backupResult = New-BasicBackup -ProjectPath $projectPath -ProjectName $ProjectConfig.name
            $syncResult.Backup = $backupResult
            
            if ($backupResult.Success) {
                Write-SyncLog "Backup criado: $($backupResult.BackupName)" "INFO" $ProjectConfig.name
                $syncResult.Steps += "BACKUP: SUCCESS - $($backupResult.BackupName)"
            } else {
                Write-SyncLog "Falha no backup: $($backupResult.Error)" "WARNING" $ProjectConfig.name
                $syncResult.Steps += "BACKUP: FAILED - $($backupResult.Error)"
            }
        } else {
            Write-SyncLog "Backup automatico ignorado" "WARNING" $ProjectConfig.name
            $syncResult.Steps += "BACKUP: SKIPPED"
        }
        
        # Passo 6: Commit e Push
        if ($Verbose) { Write-Host "Passo 6: Commit e Push" -ForegroundColor Yellow }
        Write-SyncLog "Commit e Push" "INFO" $ProjectConfig.name
        
        # Preparar mensagem de commit
        $commitMessage = if ($Message) { 
            $Message 
        } else { 
            "[$ProjectKey] Sincronizacao automatica melhorada - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 
        }
        
        # Adicionar arquivos
        Write-SyncLog "Adicionando arquivos ao staging" "INFO" $ProjectConfig.name
        git add .
        
        if ($LASTEXITCODE -ne 0) {
            Write-SyncLog "Erro ao adicionar arquivos" "ERROR" $ProjectConfig.name
            $syncResult.Steps += "GIT_ADD: FAILED"
            return $syncResult
        }
        
        # Fazer commit
        Write-SyncLog "Criando commit" "INFO" $ProjectConfig.name
        git commit -m $commitMessage
        
        if ($LASTEXITCODE -ne 0) {
            Write-SyncLog "Erro ao fazer commit" "ERROR" $ProjectConfig.name
            $syncResult.Steps += "GIT_COMMIT: FAILED"
            return $syncResult
        }
        
        # Fazer push
        Write-SyncLog "Enviando para GitHub" "INFO" $ProjectConfig.name
        if ($Force) {
            git push origin $ProjectConfig.branch --force-with-lease
        } else {
            git push origin $ProjectConfig.branch
        }
        
        if ($LASTEXITCODE -ne 0) {
            Write-SyncLog "Erro ao fazer push" "ERROR" $ProjectConfig.name
            $syncResult.Steps += "GIT_PUSH: FAILED"
            return $syncResult
        }
        
        Write-SyncLog "Sincronizacao concluida com sucesso" "INFO" $ProjectConfig.name
        $syncResult.Success = $true
        $syncResult.Steps += "COMMIT_PUSH: SUCCESS"
        
        return $syncResult
        
    }
    catch {
        Write-SyncLog "Erro na sincronizacao: $($_.Exception.Message)" "ERROR" $ProjectConfig.name
        $syncResult.Steps += "ERROR: $($_.Exception.Message)"
        return $syncResult
    }
    finally {
        Set-Location $originalLocation
    }
}

# Determinar quais projetos sincronizar
$projectsToSync = @()

if ($ProjectName) {
    if ($projects.ContainsKey($ProjectName)) {
        $projectsToSync += @{ Key = $ProjectName; Config = $projects[$ProjectName] }
        Write-SyncLog "Modo projeto especifico selecionado: $ProjectName" "INFO" "SYSTEM"
    } else {
        Write-SyncLog "Projeto '$ProjectName' nao encontrado" "ERROR" "SYSTEM"
        Write-Host "Projetos disponiveis:" -ForegroundColor Yellow
        $projects.Keys | ForEach-Object { Write-Host "   - $_" -ForegroundColor White }
        exit 1
    }
} elseif ($All) {
    Write-SyncLog "Modo todos os projetos selecionado" "INFO" "SYSTEM"
    $projects.GetEnumerator() | ForEach-Object {
        $projectsToSync += @{ Key = $_.Key; Config = $_.Value }
    }
} else {
    Write-SyncLog "Especifique um projeto (-ProjectName) ou use -All" "ERROR" "SYSTEM"
    exit 1
}

# Executar sincronizacao melhorada
$results = @()
$totalProjects = $projectsToSync.Count
$currentProject = 0

Write-SyncLog "Iniciando sincronizacao de $totalProjects projeto(s)" "INFO" "SYSTEM"

foreach ($project in $projectsToSync) {
    $currentProject++
    Write-Host "`n[$currentProject/$totalProjects] Processando: $($project.Config.name)" -ForegroundColor Gray
    
    $result = Sync-ProjectEnhanced -ProjectConfig $project.Config -ProjectKey $project.Key
    $results += $result
}

# Relatorio final melhorado
Write-Host "`n" + "=" * 70 -ForegroundColor Cyan
Write-Host "RELATORIO MELHORADO DE SINCRONIZACAO" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

$successful = ($results | Where-Object { $_.Success }).Count
$failed = ($results | Where-Object { -not $_.Success }).Count

Write-SyncLog "Relatorio final: $successful sucessos, $failed falhas" "INFO" "SYSTEM"

Write-Host "Sucessos: $successful" -ForegroundColor Green
Write-Host "Falhas: $failed" -ForegroundColor Red
Write-Host ""

foreach ($result in $results) {
    $status = if ($result.Success) { "SUCESSO" } else { "FALHA" }
    $color = if ($result.Success) { "Green" } else { "Red" }
    
    Write-Host "$status $($result.Name)" -ForegroundColor $color
    
    if ($Verbose) {
        foreach ($step in $result.Steps) {
            Write-Host "  - $step" -ForegroundColor Gray
        }
        
        if ($result.Backup -and $result.Backup.Success) {
            Write-Host "  - Backup: $($result.Backup.BackupName)" -ForegroundColor Blue
        }
        
        if ($result.SecurityCheck) {
            $secStatus = if ($result.SecurityCheck.Compliant) { "APROVADO" } else { "AVISOS" }
            Write-Host "  - Seguranca: $secStatus" -ForegroundColor $(if ($result.SecurityCheck.Compliant) { "Green" } else { "Yellow" })
        }
    }
}

Write-SyncLog "Sistema de sincronizacao melhorado finalizado" "INFO" "SYSTEM"

# Exit code baseado nos resultados
exit $(if ($failed -eq 0) { 0 } else { 1 })
