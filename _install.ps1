$global:errors = $false
$global:logFile = ".\installation.log"
$nugetSource = 'https://api.nuget.org/v3/index.json'

function Invoke-Step {
    param (
        [ScriptBlock]$Command,
        [string]$Message
    )

    Write-Host "$Message... " -NoNewline
    try {
        $result += & $Command
        $formattedOutput = ($result -join "`n") + "`n"
        $formattedOutput | Out-File $global:logFile -Encoding UTF8 -Append
        Write-Host "Done!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed!" -ForegroundColor Red
        $global:errors = $true
    }
}

Invoke-Step { dotnet new install Umbraco.Templates } "Installing the Umbraco templates"
Invoke-Step { dotnet new sln --force } "Creating a new .NET solution" 
Invoke-Step { dotnet new umbraco -n Umbraco -o src/Umbraco --force } "Creating new .NET project"
Invoke-Step { dotnet sln add src/Umbraco/Umbraco.csproj } "Adding project to solution"
Invoke-Step { dotnet add src/Umbraco/Umbraco.csproj package Umbraco.Forms -s $nugetSource } "Adding Umbraco.Forms package to project"
Invoke-Step { dotnet add src/Umbraco/Umbraco.csproj package uSync -s $nugetSource } "Adding uSync package to project"
Invoke-Step { Remove-Item .\.git\ -Recurse -Force -ErrorAction SilentlyContinue } "Removing cloned GIT repo"
Invoke-Step { git init } "Initialising new GIT repo"
Invoke-Step { git branch -M main } "Switching to 'main' branch"
Invoke-Step { Remove-Item src/Umbraco/.gitignore -Force -ErrorAction SilentlyContinue } "Removing duplicate Umbraco .gitignore file"
Invoke-Step { Remove-Item README.md -Force -ErrorAction SilentlyContinue } "Removing cloned README.md file"
Invoke-Step { dotnet build src/Umbraco/Umbraco.csproj } "Building solution"

if ($errors) {
    Write-Host "There were errors during installation. Please see 'installation.log' file for details."
} else {
    Write-Host 'Next steps:' -ForegroundColor Yellow
    Write-Host '1. Add your own remote GIT repo.' -ForegroundColor Yellow
    Write-Host '2. Open the SLN file and use the command palette to generate build assets.' -ForegroundColor Yellow
    Write-Host '3. Run the project and import using uSync via Settings.' -ForegroundColor Yellow
    Remove-Item _install.ps1 -Force -ErrorAction SilentlyContinue
}
