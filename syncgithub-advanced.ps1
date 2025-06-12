# VIBECODE SYSTEM V4.0 - Sincronizacao Multi-Projetos GitHub (Versao Avancada)
# Script avancado com logging, validacao de seguranca e backup automatico

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
$ModulesPath = Join-Path $SystemRootPath "@project-core\modules"

# Importar modulos
try {
    Import-Module (Join-Path $ModulesPath "SyncLogger.psm1") -Force
    Import-Module (Join-Path $ModulesPath "SecurityValidator.psm1") -Force
    Import-Module (Join-Path $ModulesPath "BackupManager.psm1") -Force
    
    Write-SyncInfo "Modulos carregados com sucesso" -Operation "INIT"
}
catch {
    Write-Host "ERRO: Falha ao carregar modulos: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "VIBECODE SYSTEM V4.0 - Sincronizacao Multi-Projetos (AVANCADA)" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

Write-SyncInfo "Iniciando sistema de sincronizacao avancado" -Operation "START" -Metadata @{
    Force = $Force
    DryRun = $DryRun
    ProjectName = $ProjectName
    All = $All
    SkipSecurity = $SkipSecurity
    SkipBackup = $SkipBackup
}

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

# Funcao avancada para sincronizar um projeto
function Sync-ProjectAdvanced {
    param(
        [hashtable]$ProjectConfig,
        [string]$ProjectKey
    )
    
    Write-SyncInfo "Iniciando sincronizacao avancada" -Project $ProjectConfig.name -Operation "SYNC_START"
    
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
        Write-SyncInfo "Passo 1: Validacao inicial" -Project $ProjectConfig.name -Operation "VALIDATION"
        
        if (-not (Test-Path $projectPath)) {
            Write-SyncError "Projeto nao encontrado: $projectPath" -Project $ProjectConfig.name -Operation "VALIDATION"
            $syncResult.Steps += "VALIDATION: FAILED - Projeto nao encontrado"
            return $syncResult
        }
        
        Set-Location $projectPath
        $syncResult.Steps += "VALIDATION: SUCCESS"
        
        # Passo 2: Configuracao do Git
        Write-SyncInfo "Passo 2: Configuracao do Git" -Project $ProjectConfig.name -Operation "GIT_SETUP"
        
        if (-not (Test-Path ".git")) {
            Write-SyncInfo "Inicializando repositorio Git" -Project $ProjectConfig.name -Operation "GIT_INIT"
            git init
            git remote add origin $ProjectConfig.repositoryUrl
        }
        
        $currentRemote = git remote get-url origin 2>$null
        if ($currentRemote -ne $ProjectConfig.repositoryUrl) {
            Write-SyncInfo "Atualizando remote URL" -Project $ProjectConfig.name -Operation "GIT_REMOTE"
            git remote set-url origin $ProjectConfig.repositoryUrl
        }
        
        $syncResult.Steps += "GIT_SETUP: SUCCESS"
        
        # Passo 3: Verificacao de mudancas
        Write-SyncInfo "Passo 3: Verificacao de mudancas" -Project $ProjectConfig.name -Operation "CHANGES_CHECK"
        
        $gitStatus = git status --porcelain
        if (-not $gitStatus) {
            Write-SyncInfo "Nenhuma mudanca detectada" -Project $ProjectConfig.name -Operation "CHANGES_CHECK"
            $syncResult.Success = $true
            $syncResult.Steps += "CHANGES_CHECK: NO_CHANGES"
            return $syncResult
        }
        
        Write-SyncInfo "Mudancas detectadas: $($gitStatus.Count) arquivos" -Project $ProjectConfig.name -Operation "CHANGES_CHECK"
        $syncResult.Steps += "CHANGES_CHECK: $($gitStatus.Count) arquivos"
        
        if ($DryRun) {
            Write-SyncInfo "DRY RUN - Simulacao concluida" -Project $ProjectConfig.name -Operation "DRY_RUN"
            $syncResult.Success = $true
            $syncResult.Steps += "DRY_RUN: SUCCESS"
            return $syncResult
        }
        
        # Passo 4: Validacao de seguranca
        if (-not $SkipSecurity) {
            Write-SyncInfo "Passo 4: Validacao de seguranca" -Project $ProjectConfig.name -Operation "SECURITY"
            
            $securityResult = Test-SecurityCompliance -ProjectPath $projectPath -ProjectName $ProjectConfig.name
            $syncResult.SecurityCheck = $securityResult
            
            if (-not $securityResult.Compliant) {
                Write-SyncError "Validacao de seguranca falhou: $($securityResult.Violations.Count) violacoes" -Project $ProjectConfig.name -Operation "SECURITY"
                $syncResult.Steps += "SECURITY: FAILED - $($securityResult.Violations.Count) violacoes"
                
                # Tentar remediacao automatica
                if ($securityResult.Violations.Count -gt 0) {
                    Write-SyncInfo "Tentando remediacao automatica" -Project $ProjectConfig.name -Operation "REMEDIATION"
                    $remediationResult = Invoke-SecurityRemediation -Violations $securityResult.Violations -ProjectPath $projectPath -ProjectName $ProjectConfig.name -AutoFix
                    
                    if ($remediationResult.Success) {
                        Write-SyncInfo "Remediacao automatica bem-sucedida" -Project $ProjectConfig.name -Operation "REMEDIATION"
                        $syncResult.Steps += "REMEDIATION: SUCCESS"
                    } else {
                        Write-SyncError "Remediacao automatica falhou" -Project $ProjectConfig.name -Operation "REMEDIATION"
                        $syncResult.Steps += "REMEDIATION: FAILED"
                        return $syncResult
                    }
                }
            } else {
                Write-SyncInfo "Validacao de seguranca aprovada" -Project $ProjectConfig.name -Operation "SECURITY"
                $syncResult.Steps += "SECURITY: SUCCESS"
            }
        } else {
            Write-SyncWarning "Validacao de seguranca ignorada" -Project $ProjectConfig.name -Operation "SECURITY"
            $syncResult.Steps += "SECURITY: SKIPPED"
        }
        
        # Passo 5: Backup automatico
        if (-not $SkipBackup) {
            Write-SyncInfo "Passo 5: Backup automatico" -Project $ProjectConfig.name -Operation "BACKUP"
            
            $backupResult = New-ProjectBackup -ProjectPath $projectPath -ProjectName $ProjectConfig.name -Operation "PRE_SYNC"
            $syncResult.Backup = $backupResult
            
            if ($backupResult.Success) {
                Write-SyncInfo "Backup criado: $($backupResult.BackupName)" -Project $ProjectConfig.name -Operation "BACKUP"
                $syncResult.Steps += "BACKUP: SUCCESS - $($backupResult.BackupName)"
            } else {
                Write-SyncWarning "Falha no backup: $($backupResult.Error)" -Project $ProjectConfig.name -Operation "BACKUP"
                $syncResult.Steps += "BACKUP: FAILED - $($backupResult.Error)"
            }
        } else {
            Write-SyncWarning "Backup automatico ignorado" -Project $ProjectConfig.name -Operation "BACKUP"
            $syncResult.Steps += "BACKUP: SKIPPED"
        }
        
        # Passo 6: Commit e Push
        Write-SyncInfo "Passo 6: Commit e Push" -Project $ProjectConfig.name -Operation "COMMIT_PUSH"
        
        # Preparar mensagem de commit
        $commitMessage = if ($Message) { 
            $Message 
        } else { 
            "[$ProjectKey] Sincronizacao automatica avancada - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 
        }
        
        # Adicionar arquivos
        Write-SyncInfo "Adicionando arquivos ao staging" -Project $ProjectConfig.name -Operation "GIT_ADD"
        git add .
        
        if ($LASTEXITCODE -ne 0) {
            Write-SyncError "Erro ao adicionar arquivos" -Project $ProjectConfig.name -Operation "GIT_ADD"
            $syncResult.Steps += "GIT_ADD: FAILED"
            return $syncResult
        }
        
        # Fazer commit
        Write-SyncInfo "Criando commit" -Project $ProjectConfig.name -Operation "GIT_COMMIT"
        git commit -m $commitMessage
        
        if ($LASTEXITCODE -ne 0) {
            Write-SyncError "Erro ao fazer commit" -Project $ProjectConfig.name -Operation "GIT_COMMIT"
            $syncResult.Steps += "GIT_COMMIT: FAILED"
            return $syncResult
        }
        
        # Fazer push
        Write-SyncInfo "Enviando para GitHub" -Project $ProjectConfig.name -Operation "GIT_PUSH"
        if ($Force) {
            git push origin $ProjectConfig.branch --force-with-lease
        } else {
            git push origin $ProjectConfig.branch
        }
        
        if ($LASTEXITCODE -ne 0) {
            Write-SyncError "Erro ao fazer push" -Project $ProjectConfig.name -Operation "GIT_PUSH"
            $syncResult.Steps += "GIT_PUSH: FAILED"
            return $syncResult
        }
        
        Write-SyncInfo "Sincronizacao concluida com sucesso" -Project $ProjectConfig.name -Operation "SYNC_COMPLETE"
        $syncResult.Success = $true
        $syncResult.Steps += "COMMIT_PUSH: SUCCESS"
        
        return $syncResult
        
    }
    catch {
        Write-SyncError "Erro na sincronizacao: $($_.Exception.Message)" -Project $ProjectConfig.name -Operation "SYNC_ERROR"
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
        Write-SyncInfo "Modo projeto especifico selecionado" -Project $ProjectName -Operation "MODE_SELECT"
    } else {
        Write-SyncError "Projeto '$ProjectName' nao encontrado" -Operation "MODE_SELECT"
        Write-Host "Projetos disponiveis:" -ForegroundColor Yellow
        $projects.Keys | ForEach-Object { Write-Host "   - $_" -ForegroundColor White }
        exit 1
    }
} elseif ($All) {
    Write-SyncInfo "Modo todos os projetos selecionado" -Operation "MODE_SELECT"
    $projects.GetEnumerator() | ForEach-Object {
        $projectsToSync += @{ Key = $_.Key; Config = $_.Value }
    }
} else {
    Write-SyncError "Especifique um projeto (-ProjectName) ou use -All" -Operation "MODE_SELECT"
    exit 1
}

# Executar sincronizacao avancada
$results = @()
$totalProjects = $projectsToSync.Count
$currentProject = 0

Write-SyncInfo "Iniciando sincronizacao de $totalProjects projeto(s)" -Operation "BATCH_START"

foreach ($project in $projectsToSync) {
    $currentProject++
    Write-Host "`n[$currentProject/$totalProjects] Processando: $($project.Config.name)" -ForegroundColor Gray
    
    $result = Sync-ProjectAdvanced -ProjectConfig $project.Config -ProjectKey $project.Key
    $results += $result
}

# Relatorio final avancado
Write-Host "`n" + "=" * 70 -ForegroundColor Cyan
Write-Host "RELATORIO AVANCADO DE SINCRONIZACAO" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

$successful = ($results | Where-Object { $_.Success }).Count
$failed = ($results | Where-Object { -not $_.Success }).Count

Write-SyncInfo "Relatorio final: $successful sucessos, $failed falhas" -Operation "FINAL_REPORT" -Metadata @{
    Successful = $successful
    Failed = $failed
    Total = $totalProjects
}

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
            $secStatus = if ($result.SecurityCheck.Compliant) { "APROVADO" } else { "REPROVADO" }
            Write-Host "  - Seguranca: $secStatus" -ForegroundColor $(if ($result.SecurityCheck.Compliant) { "Green" } else { "Yellow" })
        }
    }
}

Write-SyncInfo "Sistema de sincronizacao avancado finalizado" -Operation "SYSTEM_END"

# Exit code baseado nos resultados
exit $(if ($failed -eq 0) { 0 } else { 1 })
