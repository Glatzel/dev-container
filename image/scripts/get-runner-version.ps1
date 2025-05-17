$json = gh release view -R actions/runner --json tagName | ConvertFrom-Json
$version = $json.tagName.Replace("v", "")
Write-Output "$version"
"version=$version" >> "$env:GITHUB_OUTPUT"