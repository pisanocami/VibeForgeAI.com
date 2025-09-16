# Documentation Workflows Orchestrator (ASCII-safe)

param(
    [Parameter(Mandatory=$false)]
    [string]$Workflow,

    [Parameter(Mandatory=$false)]
    [switch]$DryRun,

    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "docs",

    [Parameter(Mandatory=$false)]
    [switch]$Help
)

function Show-Help {
    Write-Host @"
Documentation Workflows Orchestrator (ASCII)

USAGE:
    .\run-documentation-ascii.ps1 -Workflow <name> [options]

WORKFLOWS:
    component-docs          Analyze and document React components
    architecture-diagrams   Generate architecture diagrams
    api-docs                Generate API docs scaffold
    data-flow-diagrams      Data-flow diagrams (placeholder)
    patterns-docs           Patterns and best practices
    full-project-docs       Run all workflows
    auto-orchestrate        Choose optimal combination automatically

OPTIONS:
    -Workflow <string>      Workflow name
    -DryRun                 Do not write files
    -OutputPath <string>    Output directory (default: docs)
    -Help                   Show this help
"@
}

function Initialize-Directories {
    param([string]$BasePath)
    $dirs = @(
        "$BasePath/components",
        "$BasePath/diagrams",
        "$BasePath/api",
        "$BasePath/patterns",
        "$BasePath/best-practices",
        "project-logs/docs",
        "project-logs/diagrams"
    )
    foreach ($dir in $dirs) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Host "Created directory: $dir"
        }
    }
}

function Analyze-Components {
    param([string]$ComponentsPath, [bool]$IsDryRun)
    Write-Host "Analyzing components in: $ComponentsPath"
    if (!(Test-Path $ComponentsPath)) {
        Write-Host "Components directory not found: $ComponentsPath" -ForegroundColor Red
        return $null
    }
    $componentFiles = Get-ChildItem -Path $ComponentsPath -Filter "*.tsx" -Recurse
    $totalComponents = $componentFiles.Count
    Write-Host "Found $totalComponents components"
    return @{ totalComponents = $totalComponents; componentFiles = $componentFiles }
}

function Generate-Architecture-Diagram {
    param([string]$OutputPath, [bool]$IsDryRun)
    $diagramPath = "$OutputPath/diagrams/project-structure.md"
    if ($IsDryRun) { Write-Host "DryRun: would write $diagramPath"; return }
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $content = @'
# Project Architecture - AI VIBESHIFT

## Structure
```mermaid
graph TD
    A[AI VIBESHIFT Platform] --> B[Frontend - React/TypeScript]
    A --> C[Backend - APIs]
    A --> D[Database - Neon]
    A --> E[Deployment - Netlify]

    B --> B1[src/]
    B --> B2[public/]
    B --> B3[config files]

    B1 --> B11[components/ - UI]
    B1 --> B12[pages/ - Pages]
    B1 --> B13[contexts/ - Contexts]
    B1 --> B14[hooks/ - Hooks]
    B1 --> B15[types/ - Types]
    B1 --> B16[data/ - Mock]
    B1 --> B17[lib/ - Utils]
```
'@
    ($content + "`nGenerated: $timestamp`n") | Out-File -FilePath $diagramPath -Encoding UTF8
    Write-Host "Diagram written: $diagramPath"
}

function Generate-API-Docs {
    param([string]$OutputPath, [bool]$IsDryRun)
    Write-Host "Scanning API-related files..."
    $apiFiles = Get-ChildItem -Path "src" -Filter "*api*" -Recurse -Include "*.ts","*.tsx"
    if ($IsDryRun) { Write-Host "DryRun: found $($apiFiles.Count) api files"; return }
    $apiDocPath = "$OutputPath/api/README.md"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $content = @'
# API Documentation - AI VIBESHIFT

## Endpoints (scaffold)
- Example endpoints listed here (to be refined as backend is implemented)

## TypeScript Types (example)
```ts
interface Project { id: string; name: string; description: string; }
```
'@
    ($content + "`nAnalyzed API files: $($apiFiles.Count)`nGenerated: $timestamp`n") | Out-File -FilePath $apiDocPath -Encoding UTF8
    Write-Host "API docs written: $apiDocPath"
}

function Generate-Patterns-Docs {
    param([string]$OutputPath, [bool]$IsDryRun)
    if ($IsDryRun) { Write-Host "DryRun: patterns doc"; return }
    $path = "$OutputPath/patterns/component-patterns.md"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $content = @'
# Design Patterns - AI VIBESHIFT

## Component Patterns
- Compound Components
- Custom Hooks

## Best Practices
- Naming conventions
- File organization
'@
    ($content + "`nGenerated: $timestamp`n") | Out-File -FilePath $path -Encoding UTF8
    Write-Host "Patterns doc written: $path"
}

function Invoke-Workflow {
    param([string]$WorkflowName, [bool]$IsDryRun, [string]$OutputPath)
    Write-Host "Running workflow: $WorkflowName"
    Initialize-Directories -BasePath $OutputPath

    switch ($WorkflowName) {
        "component-docs" {
            $result = Analyze-Components -ComponentsPath "src/components" -IsDryRun $IsDryRun
            if ($result) { Write-Host "Components analyzed: $($result.totalComponents)" }
        }
        "architecture-diagrams" {
            Generate-Architecture-Diagram -OutputPath $OutputPath -IsDryRun $IsDryRun
        }
        "api-docs" {
            Generate-API-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
        }
        "patterns-docs" {
            Generate-Patterns-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
        }
        "data-flow-diagrams" {
            Write-Host "Data-flow diagrams placeholder"
        }
        "full-project-docs" {
            Analyze-Components -ComponentsPath "src/components" -IsDryRun $IsDryRun | Out-Null
            Generate-Architecture-Diagram -OutputPath $OutputPath -IsDryRun $IsDryRun
            Generate-API-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
            Generate-Patterns-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun
            Write-Host "Full project docs completed"
        }
        "auto-orchestrate" {
            $componentCount = 0
            if (Test-Path "src/components") {
                $componentCount = (Get-ChildItem -Path "src/components" -Filter "*.tsx" -Recurse -ErrorAction SilentlyContinue).Count
            }
            $hasComponentsDocs = Test-Path "$OutputPath/components"
            $hasDiagrams = Test-Path "$OutputPath/diagrams"
            $hasApi = Test-Path "$OutputPath/api"

            $combination = $null
            if ($componentCount -gt 50 -and -not $hasComponentsDocs) {
                $combination = "full-project-docs"
                Write-Host "Auto: full-project-docs"
            } elseif (-not $hasDiagrams) {
                $combination = "architecture-first"
                Write-Host "Auto: architecture-first"
            } elseif (-not $hasApi) {
                $combination = "api-focus"
                Write-Host "Auto: api-focus"
            } else {
                $combination = "maintenance-mode"
                Write-Host "Auto: maintenance-mode"
            }

            $executed = @()
            switch ($combination) {
                "full-project-docs" {
                    Analyze-Components -ComponentsPath "src/components" -IsDryRun $IsDryRun | Out-Null; $executed += "component-docs"
                    Generate-Architecture-Diagram -OutputPath $OutputPath -IsDryRun $IsDryRun; $executed += "architecture-diagrams"
                    Generate-API-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun; $executed += "api-docs"
                    Generate-Patterns-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun; $executed += "patterns-docs"
                }
                "architecture-first" {
                    Generate-Architecture-Diagram -OutputPath $OutputPath -IsDryRun $IsDryRun; $executed += "architecture-diagrams"
                    Analyze-Components -ComponentsPath "src/components" -IsDryRun $IsDryRun | Out-Null; $executed += "component-docs"
                    Generate-Patterns-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun; $executed += "patterns-docs"
                }
                "api-focus" {
                    Generate-API-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun; $executed += "api-docs"
                    Write-Host "Data-flow diagrams (placeholder)"; $executed += "data-flow-diagrams"
                    Generate-Architecture-Diagram -OutputPath $OutputPath -IsDryRun $IsDryRun; $executed += "architecture-diagrams"
                }
                "maintenance-mode" {
                    Generate-Patterns-Docs -OutputPath $OutputPath -IsDryRun $IsDryRun; $executed += "patterns-docs"
                    Analyze-Components -ComponentsPath "src/components" -IsDryRun $IsDryRun | Out-Null; $executed += "component-docs"
                    Write-Host "Data-flow diagrams (placeholder)"; $executed += "data-flow-diagrams"
                }
            }

            if (-not $IsDryRun) {
                $metricsPath = "project-logs/docs/workflow-metrics.json"
                $metrics = @{
                    workflow = "auto-orchestrate-ascii"
                    executedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    outputPath = $OutputPath
                    dryRun = $IsDryRun
                    workflowsExecuted = $executed
                }
                $metrics | ConvertTo-Json | Out-File -FilePath $metricsPath -Encoding UTF8
                Write-Host "Metrics written: $metricsPath"
            }
            Write-Host "Auto-orchestrate completed"
        }
        default {
            Write-Host "Unknown workflow: $WorkflowName" -ForegroundColor Red
            Show-Help
            return
        }
    }

    if (!$IsDryRun) {
        $metricsPath = "project-logs/docs/workflow-metrics.json"
        $metrics = @{
            workflow = $WorkflowName
            executedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            outputPath = $OutputPath
            dryRun = $IsDryRun
        }
        $metrics | ConvertTo-Json | Out-File -FilePath $metricsPath -Encoding UTF8
        Write-Host "Metrics written: $metricsPath"
    }

    Write-Host "Workflow '$WorkflowName' completed"
}

if ($Help) { Show-Help; exit 0 }
if (!$Workflow) { Write-Host "Error: -Workflow is required" -ForegroundColor Red; Show-Help; exit 1 }
try { Invoke-Workflow -WorkflowName $Workflow -IsDryRun $DryRun -OutputPath $OutputPath } catch { Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red; exit 1 }
