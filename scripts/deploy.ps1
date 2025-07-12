# deploy.ps1 - Deploys application to specified environment
# Usage: .\deploy.ps1 [dev|staging|prod]

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "staging", "prod")]
    [string]$Environment
)

Write-Host "🚀 Deploying to $Environment environment..." -ForegroundColor Cyan

# Build and push Docker image
Write-Host "📦 Building and pushing Docker image..." -ForegroundColor Green
& "$PSScriptRoot\build_and_push.ps1" -Environment $Environment

# Apply Terraform changes
Write-Host "🏗️ Applying infrastructure changes..." -ForegroundColor Green
Push-Location -Path "$PSScriptRoot\..\terraform"
terraform init
terraform apply -var-file="environments\$Environment\terraform.tfvars" -auto-approve
Pop-Location

Write-Host "✅ Deployment to $Environment completed successfully!" -ForegroundColor Green
