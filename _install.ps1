Write-Host 'Installing the Umbraco templates' -ForegroundColor Green
dotnet new install Umbraco.Templates

Write-Host 'Creating solution and project' -ForegroundColor Green
dotnet new sln --force
dotnet new umbraco -n Umbraco -o src/Umbraco --force

Write-Host 'Adding project to solution' -ForegroundColor Green
dotnet sln add src/Umbraco/Umbraco.csproj

Write-Host 'Adding packages to project' -ForegroundColor Green
$nugetSource = 'https://api.nuget.org/v3/index.json'
dotnet add src/Umbraco/Umbraco.csproj package Umbraco.Forms -s $nugetSource
dotnet add src/Umbraco/Umbraco.csproj package uSync -s $nugetSource

Write-Host 'Initialising new GIT repo' -ForegroundColor Green
Remove-Item .\.git\ -Recurse -Force -erroraction 'silentlycontinue'
try {
    git init
    git branch -M main
}
catch {
    Write-Host 'Unable to initialise git repo - do you have GIT installed?' -ForegroundColor Red
}

Write-Host 'Finishing up' -ForegroundColor Green
Remove-Item src/Umbraco/.gitignore
Remove-Item README.md
dotnet build src/Umbraco/Umbraco.csproj

Write-Host 'Next steps:' -ForegroundColor Yellow
Write-Host '1. Add your own remote GIT repo.' -ForegroundColor Yellow
Write-Host '2. Open the SLN file and use the command palette to generate build assets.' -ForegroundColor Yellow
Write-Host '3. Run the project and import using uSync via Settings.'
Remove-Item _install.ps1