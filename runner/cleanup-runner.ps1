Param ($owner = "Glatzel", [string]$repo)
if (-not $repo) {
    $repo = Read-Host "Github Repository name"
}

#Cleanup#
#Look for any old/stale dockerNode- registrations to clean up
#Windows containers cannot gracefully remove registration via powershell due to issue: https://github.com/moby/moby/issues/25982#
#For this reason we can use this scrip to cleanup old offline instances/registrations
$runnerListJson = gh api -H "Accept: application/vnd.github.v3+json" "/repos/$owner/$repo/actions/runners"
$runnerList = (ConvertFrom-Json -InputObject $runnerListJson).runners

Foreach ($runner in $runnerList) {
    try {
        if ($runner.status -eq "online") {
            write-host "Skip online runner: $($runner.name)"
            continue
        }
        If (($runner.name -like "dockerNode-*") -and ($runner.status -eq "offline")) {
            write-host "Unregistering old stale runner: $($runner.name)"
            gh api --method DELETE -H "Accept: application/vnd.github.v3+json" "/repos/$owner/$repo/actions/runners/$($runner.id)"
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
}
