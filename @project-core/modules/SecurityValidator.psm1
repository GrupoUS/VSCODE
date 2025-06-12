# VIBECODE SYSTEM V4.0 - Modulo de Validacao de Seguranca
# Modulo PowerShell para validacao de seguranca antes de commits

# Importar modulo de logging
Import-Module (Join-Path $PSScriptRoot "SyncLogger.psm1") -Force

# Configuracoes de seguranca
$script:SensitivePatterns = @(
    # Arquivos de ambiente
    "\.env$",
    "\.env\.local$",
    "\.env\.production$",
    "\.env\.development$",
    "\.env\.test$",
    
    # Chaves e tokens
    "api[_-]?key",
    "secret[_-]?key",
    "access[_-]?token",
    "auth[_-]?token",
    "private[_-]?key",
    "password",
    "passwd",
    "pwd",
    
    # Configuracoes de banco de dados
    "database[_-]?url",
    "db[_-]?connection",
    "connection[_-]?string",
    
    # Servicos externos
    "aws[_-]?access",
    "aws[_-]?secret",
    "google[_-]?api",
    "github[_-]?token",
    "stripe[_-]?key",
    "paypal[_-]?secret"
)

$script:SensitiveFiles = @(
    "*.env*",
    "*.key",
    "*.pem",
    "*.p12",
    "*.pfx",
    "id_rsa*",
    "*.credentials",
    "secrets.*",
    "config.local.*"
)

$script:AllowedEnvFiles = @(
    ".env.example",
    ".env.template",
    ".env.sample"
)

# Funcao principal de validacao
function Test-SecurityCompliance {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath,
        
        [string]$ProjectName = "UNKNOWN"
    )
    
    Write-SyncInfo "Iniciando validacao de seguranca" -Project $ProjectName -Operation "SECURITY_CHECK"
    
    $violations = @()
    $warnings = @()
    
    try {
        # Verificar arquivos staged no git
        $stagedFiles = Get-StagedFiles -ProjectPath $ProjectPath
        
        foreach ($file in $stagedFiles) {
            # Verificar arquivos sensíveis
            $fileViolation = Test-SensitiveFile -FilePath $file -ProjectName $ProjectName
            if ($fileViolation) {
                $violations += $fileViolation
            }
            
            # Verificar conteúdo de arquivos
            $contentViolations = Test-FileContent -FilePath (Join-Path $ProjectPath $file) -ProjectName $ProjectName
            if ($contentViolations) {
                $violations += $contentViolations
            }
        }
        
        # Verificar estrutura de pastas
        $structureWarnings = Test-ProjectStructure -ProjectPath $ProjectPath -ProjectName $ProjectName
        if ($structureWarnings) {
            $warnings += $structureWarnings
        }
        
        # Gerar relatorio
        $result = @{
            Compliant = ($violations.Count -eq 0)
            Violations = $violations
            Warnings = $warnings
            FilesChecked = $stagedFiles.Count
            ProjectName = $ProjectName
        }
        
        if ($violations.Count -eq 0) {
            Write-SyncInfo "Validacao de seguranca aprovada - $($stagedFiles.Count) arquivos verificados" -Project $ProjectName -Operation "SECURITY_CHECK"
        } else {
            Write-SyncError "Validacao de seguranca falhou - $($violations.Count) violacoes encontradas" -Project $ProjectName -Operation "SECURITY_CHECK"
        }
        
        return $result
        
    }
    catch {
        Write-SyncError "Erro na validacao de seguranca: $($_.Exception.Message)" -Project $ProjectName -Operation "SECURITY_CHECK"
        return @{
            Compliant = $false
            Error = $_.Exception.Message
            ProjectName = $ProjectName
        }
    }
}

# Funcao para obter arquivos staged
function Get-StagedFiles {
    param([string]$ProjectPath)
    
    $originalLocation = Get-Location
    try {
        Set-Location $ProjectPath
        $stagedFiles = git diff --cached --name-only 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $stagedFiles
        } else {
            # Se nao ha staged files, verificar todos os arquivos modificados
            return git status --porcelain | ForEach-Object { $_.Substring(3) }
        }
    }
    finally {
        Set-Location $originalLocation
    }
}

# Funcao para testar arquivos sensíveis
function Test-SensitiveFile {
    param(
        [string]$FilePath,
        [string]$ProjectName
    )
    
    $fileName = Split-Path $FilePath -Leaf
    
    # Verificar se e um arquivo permitido
    if ($fileName -in $script:AllowedEnvFiles) {
        return $null
    }
    
    # Verificar padroes de arquivos sensíveis
    foreach ($pattern in $script:SensitiveFiles) {
        if ($fileName -like $pattern) {
            Write-SyncWarning "Arquivo sensivel detectado: $FilePath" -Project $ProjectName -Operation "FILE_CHECK"
            return @{
                Type = "SENSITIVE_FILE"
                File = $FilePath
                Pattern = $pattern
                Severity = "HIGH"
                Message = "Arquivo potencialmente sensivel detectado"
            }
        }
    }
    
    return $null
}

# Funcao para testar conteudo de arquivos
function Test-FileContent {
    param(
        [string]$FilePath,
        [string]$ProjectName
    )
    
    if (-not (Test-Path $FilePath)) {
        return $null
    }
    
    $violations = @()
    
    try {
        # Ler apenas arquivos de texto
        $extension = [System.IO.Path]::GetExtension($FilePath).ToLower()
        $textExtensions = @(".js", ".ts", ".json", ".md", ".txt", ".yml", ".yaml", ".xml", ".env", ".config")
        
        if ($extension -in $textExtensions) {
            $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
            
            if ($content) {
                foreach ($pattern in $script:SensitivePatterns) {
                    if ($content -match $pattern) {
                        $violations += @{
                            Type = "SENSITIVE_CONTENT"
                            File = $FilePath
                            Pattern = $pattern
                            Severity = "MEDIUM"
                            Message = "Conteudo potencialmente sensivel encontrado"
                        }
                        
                        Write-SyncWarning "Conteudo sensivel detectado em $FilePath (padrao: $pattern)" -Project $ProjectName -Operation "CONTENT_CHECK"
                    }
                }
            }
        }
    }
    catch {
        Write-SyncDebug "Erro ao verificar conteudo de $FilePath : $($_.Exception.Message)" -Project $ProjectName
    }
    
    return $violations
}

# Funcao para testar estrutura do projeto
function Test-ProjectStructure {
    param(
        [string]$ProjectPath,
        [string]$ProjectName
    )
    
    $warnings = @()
    
    # Verificar se existe .gitignore
    $gitignorePath = Join-Path $ProjectPath ".gitignore"
    if (-not (Test-Path $gitignorePath)) {
        $warnings += @{
            Type = "MISSING_GITIGNORE"
            Severity = "LOW"
            Message = "Arquivo .gitignore nao encontrado"
        }
        Write-SyncWarning "Arquivo .gitignore nao encontrado" -Project $ProjectName -Operation "STRUCTURE_CHECK"
    }
    
    # Verificar se node_modules esta sendo commitado
    $nodeModulesPath = Join-Path $ProjectPath "node_modules"
    if ((Test-Path $nodeModulesPath) -and (Test-Path $gitignorePath)) {
        $gitignoreContent = Get-Content $gitignorePath -Raw
        if ($gitignoreContent -notmatch "node_modules") {
            $warnings += @{
                Type = "NODE_MODULES_NOT_IGNORED"
                Severity = "MEDIUM"
                Message = "node_modules pode estar sendo commitado"
            }
            Write-SyncWarning "node_modules nao esta no .gitignore" -Project $ProjectName -Operation "STRUCTURE_CHECK"
        }
    }
    
    return $warnings
}

# Funcao para remediar violacoes automaticamente
function Invoke-SecurityRemediation {
    param(
        [Parameter(Mandatory=$true)]
        [array]$Violations,
        
        [string]$ProjectPath,
        [string]$ProjectName = "UNKNOWN",
        [switch]$AutoFix
    )
    
    Write-SyncInfo "Iniciando remediacao de seguranca" -Project $ProjectName -Operation "REMEDIATION"
    
    $remediated = @()
    $failed = @()
    
    foreach ($violation in $Violations) {
        try {
            switch ($violation.Type) {
                "SENSITIVE_FILE" {
                    if ($AutoFix) {
                        $result = Remove-SensitiveFile -Violation $violation -ProjectPath $ProjectPath -ProjectName $ProjectName
                        if ($result) { $remediated += $violation } else { $failed += $violation }
                    } else {
                        Write-SyncWarning "Arquivo sensivel requer remocao manual: $($violation.File)" -Project $ProjectName
                        $failed += $violation
                    }
                }
                "SENSITIVE_CONTENT" {
                    Write-SyncWarning "Conteudo sensivel requer revisao manual: $($violation.File)" -Project $ProjectName
                    $failed += $violation
                }
            }
        }
        catch {
            Write-SyncError "Erro na remediacao: $($_.Exception.Message)" -Project $ProjectName -Operation "REMEDIATION"
            $failed += $violation
        }
    }
    
    return @{
        Remediated = $remediated
        Failed = $failed
        Success = ($failed.Count -eq 0)
    }
}

# Funcao para remover arquivo sensível
function Remove-SensitiveFile {
    param(
        [hashtable]$Violation,
        [string]$ProjectPath,
        [string]$ProjectName
    )
    
    $filePath = Join-Path $ProjectPath $Violation.File
    
    try {
        # Remover do staging area
        $originalLocation = Get-Location
        Set-Location $ProjectPath
        git reset HEAD $Violation.File 2>$null
        
        # Adicionar ao .gitignore se nao estiver
        $gitignorePath = Join-Path $ProjectPath ".gitignore"
        if (Test-Path $gitignorePath) {
            $gitignoreContent = Get-Content $gitignorePath -Raw
            if ($gitignoreContent -notmatch [regex]::Escape($Violation.File)) {
                Add-Content $gitignorePath "`n# Arquivo sensivel removido automaticamente`n$($Violation.File)"
                Write-SyncInfo "Arquivo adicionado ao .gitignore: $($Violation.File)" -Project $ProjectName -Operation "REMEDIATION"
            }
        }
        
        Set-Location $originalLocation
        return $true
    }
    catch {
        Write-SyncError "Erro ao remover arquivo sensivel: $($_.Exception.Message)" -Project $ProjectName -Operation "REMEDIATION"
        return $false
    }
}

# Exportar funcoes publicas
Export-ModuleMember -Function Test-SecurityCompliance, Invoke-SecurityRemediation
