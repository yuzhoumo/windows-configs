###################
# O&O Shutup Tweaks
###################

# Force run as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
    $arguments = "& '" +$myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

$link = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
$scriptdir = Split-Path $MyInvocation.MyCommand.Path
$cfg = "$scriptdir\..\..\assets\ooshutup10.cfg"
$app = "$scriptdir\OOSU10.exe"

Write-Host "> Downloading O&O Shutup latest release"
Invoke-WebRequest $link -Out $app

Write-Host "> Applying O&O Shutup configuration"
Start-Process $app -ArgumentList "`"$cfg`" /quiet" -wait

Write-Host "> Deleting O&O executable"
Remove-Item $app -force
