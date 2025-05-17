$ROOT = git rev-parse --show-toplevel
$json = gh release view -R actions/runner --json tagName | ConvertFrom-Json
$version = $json.tagName.Replace("v", "")
Write-Output "$version"
