# VIBECODE SYSTEM V4.0 - Modulo de Gerenciamento de Backup
# Modulo PowerShell para backup automatico antes de operacoes criticas

# Importar modulo de logging
Import-Module (Join-Path $PSScriptRoot "SyncLogger.psm1") -Force

# Configuracoes de backup
$script:BackupBasePath = "@project-core\backups"
$script:SystemRootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"
$script:MaxBackupAge = 7 # dias
$script:MaxBackupsPerProject = 10

# Funcao principal para criar backup
function New-ProjectBackup {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath,
        
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        
        [string]$Operation = "SYNC",
        
        [switch]$IncludeGitHistory
    )
    
    Write-SyncInfo "Iniciando backup do projeto" -Project $ProjectName -Operation "BACKUP"
    
    try {
        # Criar estrutura de backup
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupName = "$ProjectName`_$Operation`_$timestamp"
        $backupPath = Join-Path $script:SystemRootPath "$script:BackupBasePath\$backupName"
        
        # Garantir que o diretorio de backup existe
        if (-not (Test-Path (Split-Path $backupPath -Parent))) {
            New-Item -ItemType Directory -Path (Split-Path $backupPath -Parent) -Force | Out-Null
        }
        
        # Criar backup
        $backupResult = Copy-ProjectFiles -SourcePath $ProjectPath -BackupPath $backupPath -ProjectName $ProjectName -IncludeGitHistory:$IncludeGitHistory
        
        if ($backupResult.Success) {
            # Criar manifesto do backup
            $manifest = Create-BackupManifest -BackupPath $backupPath -ProjectName $ProjectName -Operation $Operation -SourcePath $ProjectPath
            
            # Limpar backups antigos
            Remove-OldBackups -ProjectName $ProjectName
            
            Write-SyncInfo "Backup criado com sucesso: $backupName" -Project $ProjectName -Operation "BACKUP" -Metadata @{
                BackupPath = $backupPath
                Size = $backupResult.Size
                Files = $backupResult.FileCount
            }
            
            return @{
                Success = $true
                BackupPath = $backupPath
                BackupName = $backupName
                Manifest = $manifest
                Size = $backupResult.Size
                FileCount = $backupResult.FileCount
            }
        } else {
            Write-SyncError "Falha ao criar backup: $($backupResult.Error)" -Project $ProjectName -Operation "BACKUP"
            return @{
                Success = $false
                Error = $backupResult.Error
            }
        }
        
    }
    catch {
        Write-SyncError "Erro no processo de backup: $($_.Exception.Message)" -Project $ProjectName -Operation "BACKUP"
        return @{
            Success = $false
            Error = $_.Exception.Message
        }
    }
}

# Funcao para copiar arquivos do projeto
function Copy-ProjectFiles {
    param(
        [string]$SourcePath,
        [string]$BackupPath,
        [string]$ProjectName,
        [switch]$IncludeGitHistory
    )
    
    try {
        # Criar diretorio de backup
        New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
        
        # Definir exclusoes
        $excludePatterns = @(
            "node_modules",
            ".next",
            "dist",
            "build",
            "*.log",
            "*.tmp",
            ".cache"
        )
        
        if (-not $IncludeGitHistory) {
            $excludePatterns += ".git"
        }
        
        # Copiar arquivos
        $fileCount = 0
        $totalSize = 0
        
        Get-ChildItem -Path $SourcePath -Recurse | ForEach-Object {
            $relativePath = $_.FullName.Substring($SourcePath.Length + 1)
            $shouldExclude = $false
            
            # Verificar exclusoes
            foreach ($pattern in $excludePatterns) {
                if ($relativePath -like "*$pattern*") {
                    $shouldExclude = $true
                    break
                }
            }
            
            if (-not $shouldExclude) {
                $destPath = Join-Path $BackupPath $relativePath
                $destDir = Split-Path $destPath -Parent
                
                if (-not (Test-Path $destDir)) {
                    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                }
                
                if ($_.PSIsContainer -eq $false) {
                    Copy-Item $_.FullName $destPath -Force
                    $fileCount++
                    $totalSize += $_.Length
                }
            }
        }
        
        Write-SyncDebug "Backup copiado: $fileCount arquivos, $([math]::Round($totalSize/1MB, 2)) MB" -Project $ProjectName -Operation "BACKUP"
        
        return @{
            Success = $true
            FileCount = $fileCount
            Size = $totalSize
        }
        
    }
    catch {
        return @{
            Success = $false
            Error = $_.Exception.Message
        }
    }
}

# Funcao para criar manifesto do backup
function Create-BackupManifest {
    param(
        [string]$BackupPath,
        [string]$ProjectName,
        [string]$Operation,
        [string]$SourcePath
    )
    
    try {
        $manifest = @{
            BackupInfo = @{
                ProjectName = $ProjectName
                Operation = $Operation
                Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                SourcePath = $SourcePath
                BackupPath = $BackupPath
                CreatedBy = "VIBECODE SYSTEM V4.0"
            }
            SystemInfo = @{
                ComputerName = $env:COMPUTERNAME
                UserName = $env:USERNAME
                PowerShellVersion = $PSVersionTable.PSVersion.ToString()
                OSVersion = [System.Environment]::OSVersion.VersionString
            }
            ProjectInfo = @{
                GitBranch = Get-GitBranch -ProjectPath $SourcePath
                GitCommit = Get-GitCommit -ProjectPath $SourcePath
                HasUncommittedChanges = Test-UncommittedChanges -ProjectPath $SourcePath
            }
        }
        
        # Salvar manifesto
        $manifestPath = Join-Path $BackupPath "backup-manifest.json"
        $manifest | ConvertTo-Json -Depth 10 | Out-File $manifestPath -Encoding UTF8
        
        return $manifest
        
    }
    catch {
        Write-SyncWarning "Erro ao criar manifesto: $($_.Exception.Message)" -Project $ProjectName -Operation "BACKUP"
        return $null
    }
}

# Funcao para obter branch atual do Git
function Get-GitBranch {
    param([string]$ProjectPath)
    
    try {
        $originalLocation = Get-Location
        Set-Location $ProjectPath
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        Set-Location $originalLocation
        return $branch
    }
    catch {
        return "unknown"
    }
}

# Funcao para obter commit atual do Git
function Get-GitCommit {
    param([string]$ProjectPath)
    
    try {
        $originalLocation = Get-Location
        Set-Location $ProjectPath
        $commit = git rev-parse HEAD 2>$null
        Set-Location $originalLocation
        return $commit
    }
    catch {
        return "unknown"
    }
}

# Funcao para verificar mudancas nao commitadas
function Test-UncommittedChanges {
    param([string]$ProjectPath)
    
    try {
        $originalLocation = Get-Location
        Set-Location $ProjectPath
        $status = git status --porcelain 2>$null
        Set-Location $originalLocation
        return ($status.Count -gt 0)
    }
    catch {
        return $false
    }
}

# Funcao para remover backups antigos
function Remove-OldBackups {
    param([string]$ProjectName)
    
    try {
        $backupDir = Join-Path $script:SystemRootPath $script:BackupBasePath
        
        if (Test-Path $backupDir) {
            # Remover por idade
            $cutoffDate = (Get-Date).AddDays(-$script:MaxBackupAge)
            Get-ChildItem $backupDir -Directory | Where-Object {
                $_.Name -like "$ProjectName`_*" -and $_.CreationTime -lt $cutoffDate
            } | Remove-Item -Recurse -Force
            
            # Manter apenas os N backups mais recentes
            $projectBackups = Get-ChildItem $backupDir -Directory | Where-Object {
                $_.Name -like "$ProjectName`_*"
            } | Sort-Object CreationTime -Descending
            
            if ($projectBackups.Count -gt $script:MaxBackupsPerProject) {
                $backupsToRemove = $projectBackups | Select-Object -Skip $script:MaxBackupsPerProject
                $backupsToRemove | Remove-Item -Recurse -Force
                
                Write-SyncInfo "Removidos $($backupsToRemove.Count) backups antigos" -Project $ProjectName -Operation "CLEANUP"
            }
        }
    }
    catch {
        Write-SyncWarning "Erro ao limpar backups antigos: $($_.Exception.Message)" -Project $ProjectName -Operation "CLEANUP"
    }
}

# Funcao para restaurar backup
function Restore-ProjectBackup {
    param(
        [Parameter(Mandatory=$true)]
        [string]$BackupName,
        
        [Parameter(Mandatory=$true)]
        [string]$RestorePath,
        
        [string]$ProjectName = "UNKNOWN",
        
        [switch]$Force
    )
    
    Write-SyncInfo "Iniciando restauracao de backup: $BackupName" -Project $ProjectName -Operation "RESTORE"
    
    try {
        $backupPath = Join-Path $script:SystemRootPath "$script:BackupBasePath\$BackupName"
        
        if (-not (Test-Path $backupPath)) {
            Write-SyncError "Backup nao encontrado: $BackupName" -Project $ProjectName -Operation "RESTORE"
            return @{ Success = $false; Error = "Backup nao encontrado" }
        }
        
        # Verificar se o destino existe
        if ((Test-Path $RestorePath) -and -not $Force) {
            Write-SyncWarning "Destino ja existe. Use -Force para sobrescrever" -Project $ProjectName -Operation "RESTORE"
            return @{ Success = $false; Error = "Destino ja existe" }
        }
        
        # Criar backup do estado atual antes da restauracao
        if (Test-Path $RestorePath) {
            $preRestoreBackup = New-ProjectBackup -ProjectPath $RestorePath -ProjectName "$ProjectName-PreRestore" -Operation "PRE_RESTORE"
            Write-SyncInfo "Backup pre-restauracao criado: $($preRestoreBackup.BackupName)" -Project $ProjectName -Operation "RESTORE"
        }
        
        # Restaurar arquivos
        if (Test-Path $RestorePath) {
            Remove-Item $RestorePath -Recurse -Force
        }
        
        Copy-Item $backupPath $RestorePath -Recurse -Force
        
        Write-SyncInfo "Backup restaurado com sucesso" -Project $ProjectName -Operation "RESTORE" -Metadata @{
            BackupName = $BackupName
            RestorePath = $RestorePath
        }
        
        return @{
            Success = $true
            BackupName = $BackupName
            RestorePath = $RestorePath
        }
        
    }
    catch {
        Write-SyncError "Erro na restauracao: $($_.Exception.Message)" -Project $ProjectName -Operation "RESTORE"
        return @{
            Success = $false
            Error = $_.Exception.Message
        }
    }
}

# Funcao para listar backups
function Get-ProjectBackups {
    param([string]$ProjectName = $null)
    
    try {
        $backupDir = Join-Path $script:SystemRootPath $script:BackupBasePath
        
        if (-not (Test-Path $backupDir)) {
            return @()
        }
        
        $backups = Get-ChildItem $backupDir -Directory | Where-Object {
            if ($ProjectName) {
                $_.Name -like "$ProjectName`_*"
            } else {
                $true
            }
        } | Sort-Object CreationTime -Descending
        
        $backupList = @()
        
        foreach ($backup in $backups) {
            $manifestPath = Join-Path $backup.FullName "backup-manifest.json"
            $manifest = $null
            
            if (Test-Path $manifestPath) {
                try {
                    $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
                }
                catch {
                    # Manifesto corrompido, ignorar
                }
            }
            
            $backupList += @{
                Name = $backup.Name
                CreationTime = $backup.CreationTime
                Size = (Get-ChildItem $backup.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum
                Path = $backup.FullName
                Manifest = $manifest
            }
        }
        
        return $backupList
        
    }
    catch {
        Write-SyncError "Erro ao listar backups: $($_.Exception.Message)"
        return @()
    }
}

# Exportar funcoes publicas
Export-ModuleMember -Function New-ProjectBackup, Restore-ProjectBackup, Get-ProjectBackups
