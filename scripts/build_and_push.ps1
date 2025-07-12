# build_and_push.ps1 - Builds and pushes Docker image to GitHub Packages
# Usage: .\build_and_push.ps1 [dev|staging|prod]

param (
    [ValidateSet("dev", "staging", "prod")]
    [string]$Environment = "dev"
)

# Try to get version from git, otherwise use default
try {
    $Version = git describe --tags --always
}
catch {
    $Version = "v0.1.0"
}

$GithubUser = "Jeysibn"  # Replace with your GitHub username
$GithubRepo = "my-app"   # Replace with your repository name
$ImageName = "ghcr.io/$GithubUser/$GithubRepo"
$Tag = "$ImageName`:$Environment-$Version"

Write-Host "🔨 Building Docker image: $Tag" -ForegroundColor Cyan
docker build -t $Tag -f "$PSScriptRoot\..\docker\Dockerfile" "$PSScriptRoot\.."

# Check if GitHub token is set
if (-not $env:GITHUB_TOKEN) {
    Write-Host "⚠️ GITHUB_TOKEN not set. Please set it to push to GitHub Packages." -ForegroundColor Red
    exit 1
}

Write-Host "🔑 Logging in to GitHub Packages..." -ForegroundColor Cyan
$env:GITHUB_TOKEN | docker login ghcr.io -u $GithubUser --password-stdin

Write-Host "⬆️ Pushing image to GitHub Packages..." -ForegroundColor Cyan
docker push $Tag

Write-Host "✅ Docker image built and pushed successfully: $Tag" -ForegroundColor Green
