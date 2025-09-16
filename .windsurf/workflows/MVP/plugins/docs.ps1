function Invoke-MVPPlugin {
  param([hashtable]$Context)
  Write-Host "[docs] Plugin ejecutado" -ForegroundColor Cyan
  if ($null -ne $Context) {
    Write-Host ("Contexto: " + ($Context | ConvertTo-Json -Compress)) -ForegroundColor DarkGray
  }
  [pscustomobject]@{ Name = 'docs'; Status = 'ok' }
}
