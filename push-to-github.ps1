# PowerShell script to push to GitHub
# Usage: .\push-to-github.ps1 -GitHubUrl "https://github.com/yourusername/reponame.git"

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUrl
)

Write-Host "Adding GitHub remote..." -ForegroundColor Green
git remote add origin $GitHubUrl

Write-Host "Pushing to GitHub..." -ForegroundColor Green
git push -u origin main

Write-Host "Done! Your code is now on GitHub." -ForegroundColor Green

