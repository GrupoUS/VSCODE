# VIBECODE SYSTEM V4.0 - Modulo de Logging para Sincronizacao
# Modulo PowerShell para logging avancado das operacoes de sincronizacao

# Configuracoes globais
$script:LogPath = "@project-core\logs\sync-operations.log"
$script:SystemRootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"
$script:MaxLogSize = 10MB
$script:LogRetentionDays = 30

# Enum para niveis de log
enum LogLevel {
    DEBUG = 0
    INFO = 1
    WARNING = 2
    ERROR = 3
    CRITICAL = 4
}

# Funcao principal de logging
function Write-SyncLog {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [LogLevel]$Level = [LogLevel]::INFO,
        
        [string]$Project = "SYSTEM",
        
        [string]$Operation = "",
        
        [hashtable]$Metadata = @{}
    )
    
    try {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $levelStr = $Level.ToString().ToUpper()
        
        # Construir linha de log
        $logLine = "[$timestamp] [$levelStr] [$Project]"
        
        if ($Operation) {
            $logLine += " [$Operation]"
        }
        
        $logLine += " $Message"
        
        # Adicionar metadata se fornecida
        if ($Metadata.Count -gt 0) {
            $metadataStr = ($Metadata.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "; "
            $logLine += " | Metadata: $metadataStr"
        }
        
        # Garantir que o diretorio de logs existe
        $fullLogPath = Join-Path $script:SystemRootPath $script:LogPath
        $logDir = Split-Path $fullLogPath -Parent
        
        if (-not (Test-Path $logDir)) {
            New-Item -ItemType Directory -Path $logDir -Force | Out-Null
        }
        
        # Escrever no arquivo de log
        Add-Content -Path $fullLogPath -Value $logLine -Encoding UTF8
        
        # Rotacionar logs se necessario
        Invoke-LogRotation -LogPath $fullLogPath
        
        # Exibir no console com cores baseadas no nivel
        $color = switch ($Level) {
            ([LogLevel]::DEBUG) { "Gray" }
            ([LogLevel]::INFO) { "White" }
            ([LogLevel]::WARNING) { "Yellow" }
            ([LogLevel]::ERROR) { "Red" }
            ([LogLevel]::CRITICAL) { "Magenta" }
        }
        
        Write-Host $logLine -ForegroundColor $color
        
    }
    catch {
        Write-Warning "Erro ao escrever log: $($_.Exception.Message)"
    }
}

# Funcao para rotacao de logs
function Invoke-LogRotation {
    param([string]$LogPath)
    
    try {
        if (Test-Path $LogPath) {
            $logFile = Get-Item $LogPath
            
            # Verificar tamanho do arquivo
            if ($logFile.Length -gt $script:MaxLogSize) {
                $backupPath = $LogPath -replace "\.log$", "_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
                Move-Item $LogPath $backupPath
                
                # Criar novo arquivo de log
                "# VIBECODE SYSTEM V4.0 - Log de Operacoes de Sincronizacao (Rotacionado)" | Out-File $LogPath -Encoding UTF8
            }
            
            # Limpar logs antigos
            $logDir = Split-Path $LogPath -Parent
            $cutoffDate = (Get-Date).AddDays(-$script:LogRetentionDays)
            
            Get-ChildItem $logDir -Filter "*.log" | Where-Object { 
                $_.LastWriteTime -lt $cutoffDate -and $_.Name -like "*_*" 
            } | Remove-Item -Force
        }
    }
    catch {
        Write-Warning "Erro na rotacao de logs: $($_.Exception.Message)"
    }
}

# Funcoes de conveniencia para diferentes niveis
function Write-SyncDebug {
    param([string]$Message, [string]$Project = "SYSTEM", [string]$Operation = "", [hashtable]$Metadata = @{})
    Write-SyncLog -Message $Message -Level ([LogLevel]::DEBUG) -Project $Project -Operation $Operation -Metadata $Metadata
}

function Write-SyncInfo {
    param([string]$Message, [string]$Project = "SYSTEM", [string]$Operation = "", [hashtable]$Metadata = @{})
    Write-SyncLog -Message $Message -Level ([LogLevel]::INFO) -Project $Project -Operation $Operation -Metadata $Metadata
}

function Write-SyncWarning {
    param([string]$Message, [string]$Project = "SYSTEM", [string]$Operation = "", [hashtable]$Metadata = @{})
    Write-SyncLog -Message $Message -Level ([LogLevel]::WARNING) -Project $Project -Operation $Operation -Metadata $Metadata
}

function Write-SyncError {
    param([string]$Message, [string]$Project = "SYSTEM", [string]$Operation = "", [hashtable]$Metadata = @{})
    Write-SyncLog -Message $Message -Level ([LogLevel]::ERROR) -Project $Project -Operation $Operation -Metadata $Metadata
}

function Write-SyncCritical {
    param([string]$Message, [string]$Project = "SYSTEM", [string]$Operation = "", [hashtable]$Metadata = @{})
    Write-SyncLog -Message $Message -Level ([LogLevel]::CRITICAL) -Project $Project -Operation $Operation -Metadata $Metadata
}

# Funcao para obter estatisticas de log
function Get-SyncLogStats {
    param(
        [int]$LastHours = 24,
        [string]$Project = $null
    )
    
    try {
        $fullLogPath = Join-Path $script:SystemRootPath $script:LogPath
        
        if (-not (Test-Path $fullLogPath)) {
            return @{ Error = "Arquivo de log nao encontrado" }
        }
        
        $cutoffTime = (Get-Date).AddHours(-$LastHours)
        $logContent = Get-Content $fullLogPath
        
        $stats = @{
            TotalLines = 0
            DEBUG = 0
            INFO = 0
            WARNING = 0
            ERROR = 0
            CRITICAL = 0
            Projects = @{}
            TimeRange = "$LastHours horas"
        }
        
        foreach ($line in $logContent) {
            if ($line -match '^\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\] \[(\w+)\] \[(\w+)\]') {
                $logTime = [DateTime]::ParseExact($matches[1], "yyyy-MM-dd HH:mm:ss", $null)
                $level = $matches[2]
                $projectName = $matches[3]
                
                if ($logTime -ge $cutoffTime) {
                    if (-not $Project -or $projectName -eq $Project) {
                        $stats.TotalLines++
                        $stats[$level]++
                        
                        if (-not $stats.Projects.ContainsKey($projectName)) {
                            $stats.Projects[$projectName] = 0
                        }
                        $stats.Projects[$projectName]++
                    }
                }
            }
        }
        
        return $stats
    }
    catch {
        return @{ Error = "Erro ao processar estatisticas: $($_.Exception.Message)" }
    }
}

# Funcao para limpar logs
function Clear-SyncLogs {
    param([switch]$Force)
    
    try {
        $fullLogPath = Join-Path $script:SystemRootPath $script:LogPath
        
        if ($Force -or (Read-Host "Confirma limpeza dos logs? (s/N)") -eq 's') {
            if (Test-Path $fullLogPath) {
                Remove-Item $fullLogPath -Force
                Write-SyncInfo "Logs limpos com sucesso"
                return $true
            }
        }
        return $false
    }
    catch {
        Write-SyncError "Erro ao limpar logs: $($_.Exception.Message)"
        return $false
    }
}

# Exportar funcoes publicas
Export-ModuleMember -Function Write-SyncLog, Write-SyncDebug, Write-SyncInfo, Write-SyncWarning, Write-SyncError, Write-SyncCritical, Get-SyncLogStats, Clear-SyncLogs
