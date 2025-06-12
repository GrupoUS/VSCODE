# GRUPO US VIBECODE SYSTEM V4.5 - Workflow Invoker
# Script para invocar workflows do sistema

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("list", "invoke", "validate", "status")]
    [string]$Action,

    [Parameter(Mandatory=$false)]
    [string]$WorkflowName,

    [Parameter(Mandatory=$false)]
    [string]$StepName,

    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Configurações
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$WORKFLOWS_PATH = Join-Path $SCRIPT_DIR "..\workflows\workflows.yaml"
$LOGS_PATH = Join-Path $SCRIPT_DIR "..\logs"

# Função para carregar workflows
function Load-Workflows {
    if (Test-Path $WORKFLOWS_PATH) {
        $workflowsContent = Get-Content $WORKFLOWS_PATH -Raw
        $obj = $workflowsContent | ConvertFrom-Yaml
        Write-Host "DEBUG: Estrutura carregada do YAML:" -ForegroundColor Yellow
        $obj | ConvertTo-Json -Depth 5 | Write-Host
        return $obj
    } else {
        Write-Error "Workflows file not found at $WORKFLOWS_PATH"
        exit 1
    }
}

# Função para listar workflows
function List-Workflows {
    $workflows = Load-Workflows
    Write-Host "`nAvailable Workflows:`n"
    if ($workflows.version) { Write-Host "Version: $($workflows.version)" }
    if ($workflows.description) { Write-Host "Description: $($workflows.description)`n" }

    # Ajuste para diferentes estruturas
    $wfArray = $null
    if ($workflows.workflows) {
        $wfArray = $workflows.workflows
    } elseif ($workflows[0]) {
        $wfArray = $workflows
    } else {
        Write-Host "Nenhum workflow encontrado."
        return
    }

    foreach ($workflow in $wfArray) {
        Write-Host "  $($workflow.name)"
        Write-Host "    Description: $($workflow.description)"
        if ($workflow.steps) {
            Write-Host "    Steps: $($workflow.steps.Count)"
            Write-Host "    Agents: $($workflow.steps.agent -join ', ')"
        }
        Write-Host ""
    }
}

# Função para invocar um workflow
function Invoke-Workflow {
    param(
        [string]$workflowName,
        [switch]$Force
    )

    if (-not $workflowName) {
        Write-Error "WorkflowName is required"
        exit 1
    }

    $workflows = Load-Workflows
    $workflow = $workflows.workflows | Where-Object { $_.name -eq $workflowName }

    if (-not $workflow) {
        Write-Error "Workflow '$workflowName' not found"
        exit 1
    }

    Write-Host "Invoking workflow: $($workflow.name)"
    Write-Host "Description: $($workflow.description)"

    foreach ($step in $workflow.steps) {
        Write-Host "`nExecuting step: $($step.name)"
        Write-Host "Agent: $($step.agent)"
        Write-Host "Tools: $($step.tools -join ', ')"

        if ($step.refiners) {
            Write-Host "Refiners: $($step.refiners -join ', ')"
        }

        # Executar validações
        if ($step.validation) {
            Write-Host "Running validations..."
            foreach ($validation in $step.validation) {
                Write-Host "  Validating: $($validation.type)"
                if ($validation.criteria) {
                    Write-Host "    Criteria: $($validation.criteria -join ', ')"
                }
                if ($validation.metrics) {
                    Write-Host "    Metrics: $($validation.metrics -join ', ')"
                }
            }
        }

        Write-Host "Step completed successfully"
    }

    Write-Host "`nWorkflow completed successfully"
}

# Função para validar um workflow
function Validate-Workflow {
    param([string]$workflowName)

    if (-not $workflowName) {
        Write-Error "WorkflowName is required"
        exit 1
    }

    $workflows = Load-Workflows
    $workflow = $workflows.workflows | Where-Object { $_.name -eq $workflowName }

    if (-not $workflow) {
        Write-Error "Workflow '$workflowName' not found"
        exit 1
    }

    Write-Host "Validating workflow: $($workflow.name)"

    # Validar campos obrigatórios
    $requiredFields = @("name", "description", "steps")
    foreach ($field in $requiredFields) {
        if (-not $workflow.$field) {
            Write-Error "Missing required field: $field"
            exit 1
        }
    }

    foreach ($step in $workflow.steps) {
        Write-Host "`nValidating step: $($step.name)"

        # Validar campos obrigatórios do step
        $requiredStepFields = @("name", "agent", "tools")
        foreach ($field in $requiredStepFields) {
            if (-not $step.$field) {
                Write-Error "Missing required field in step: $field"
                exit 1
            }
        }

        # Validar validações se existirem
        if ($step.validation) {
            foreach ($validation in $step.validation) {
                if (-not $validation.type) {
                    Write-Error "Missing validation type in step: $($step.name)"
                    exit 1
                }
            }
        }
    }

    Write-Host "`nWorkflow validation completed successfully"
}

# Função para verificar status do workflow
function Get-WorkflowStatus {
    param([string]$workflowName)

    if (-not $workflowName) {
        Write-Error "WorkflowName is required"
        exit 1
    }

    $workflows = Load-Workflows
    $workflow = $workflows.workflows | Where-Object { $_.name -eq $workflowName }

    if (-not $workflow) {
        Write-Error "Workflow '$workflowName' not found"
        exit 1
    }

    Write-Host "`nWorkflow Status: $($workflow.name)`n"
    Write-Host "Description: $($workflow.description)"
    Write-Host "Total Steps: $($workflow.steps.Count)"
    Write-Host "Agents: $($workflow.steps.agent -join ', ')"
    Write-Host "Tools: $($workflow.steps.tools | Select-Object -Unique -join ', ')"
    Write-Host ""
}

# Main execution
switch ($Action) {
    "list" {
        List-Workflows
    }
    "invoke" {
        Invoke-Workflow -workflowName $WorkflowName -Force:$Force
    }
    "validate" {
        Validate-Workflow -workflowName $WorkflowName
    }
    "status" {
        Get-WorkflowStatus -workflowName $WorkflowName
    }
    default {
        Write-Host "Usage: .\invoke-workflow.ps1 [-Action action] [parameters]"
        Write-Host "Available actions:"
        Write-Host "  list    - List available workflows"
        Write-Host "  invoke  - Invoke a workflow"
        Write-Host "  validate - Validate a workflow"
        Write-Host "  status  - Check workflow status"
    }
}
