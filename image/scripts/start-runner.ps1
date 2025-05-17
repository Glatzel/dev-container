# pwsh runner start script

# Read environment variables
$GH_OWNER = $env:GH_OWNER
$GH_REPOSITORY = $env:GH_REPOSITORY
$GH_TOKEN = $env:GH_TOKEN
$USE_PROXY = $env:USE_PROXY

sudo su - runner

# Set Proxy
if ($USE_PROXY) {
    $env:HTTP_PROXY = "http://host.docker.internal:10808"
    $env:HTTPS_PROXY = "http://host.docker.internal:10808"
    $env:http_proxy = "http://host.docker.internal:10808"
    $env:https_proxy = "http://host.docker.internal:10808"
    $env:NO_PROXY = "localhost,127.0.0.1,host.docker.internal"
    git config --global http.proxy 'http://host.docker.internal:10808'
    git config --global https.proxy 'http://host.docker.internal:10808'

}

# Generate random 5-character lowercase alphanumeric suffix
$runnerBaseName = "dockerNode-"
$runnerName = $runnerBaseName + (((New-Guid).Guid).replace("-", "")).substring(0, 5)

# Get registration token from GitHub API
$jsonObj = gh api --method POST -H "Accept: application/vnd.github.v3+json" "/repos/$repo/actions/runners/registration-token"
$regToken = (ConvertFrom-Json -InputObject $jsonObj).token

# Change directory to actions-runner folder
Set-Location -Path '/home/runner/actions-runner'

# Configure the runner (unattended mode)
./config.sh --unattended --url "https://github.com/$GH_OWNER/$GH_REPOSITORY" --token $regToken --name $runnerName

# Start the runner and wait for it to finish
./run.sh