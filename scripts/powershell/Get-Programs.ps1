##############################
# Install Programs From Winget
##############################

# Force run as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
    $arguments = "& '" +$myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

$scriptDir = Split-Path $MyInvocation.MyCommand.Path
$packageList = "$scriptDir\..\..\assets\packages.json"
winget import -i "$packageList --accept-package-agreements
