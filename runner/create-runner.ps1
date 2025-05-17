param(
  [Parameter(Mandatory = $false)]
  [string]$Owner = 'Glatzel',

  [Parameter(Mandatory = $false)]
  [string]$Repo = $env:GH_REPOSITORY,

  [Parameter(Mandatory = $false)]
  [string]$Token = $env:GH_TOKEN,

  [Parameter(Mandatory = $false)]
  [int]$Count,

  [switch] $Proxy
)


# Prompt for Repo if still missing
if (-not $Repo) {
  do {
    $Repo = Read-Host 'Enter GitHub repository name'
  } while (-not $Repo)
}

# Prompt for Token if still missing
if (-not $Token) {
  do {
    $Token = Read-Host 'Enter GitHub registration token'
  } while (-not $Token)
}

# Prompt for Count if missing or not a positive integer
if (-not $Count -or $Count -lt 1) {
  do {
    $raw = Read-Host 'Enter number of runners to start (must be >= 1)'
  } while (-not [int]::TryParse($raw, [ref]$Count) -or $Count -lt 1)
}
# Set Proxy
# Confirm values
Write-Host "Runner count: $Count"
Write-Host "Owner:        $Owner"
Write-Host "Repository:   $Repo"
Write-Host "Token:        ************"
Write-Host "Proxy:        $Proxy"
Write-Host ""

# Change to script directory
Set-Location $PSScriptRoot

# Export into environment for compose
$env:GH_OWNER = $Owner
$env:GH_REPOSITORY = $Repo
$env:GH_TOKEN = $Token
if ($Proxy) {
  $env:HTTP_PROXY = "http://host.docker.internal:10808"
  $env:HTTPS_PROXY = "http://host.docker.internal:10808"
  $env:http = "http://host.docker.internal:10808"
  $env:https_proxy = "http://host.docker.internal:10808"
}


# Launch runners
docker-compose -p $Repo up --scale runner=$Count -d
