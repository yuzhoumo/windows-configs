# activate Windows using MAS 1.7 (Microsoft Activation Scripts)
# author: Yuzhou "Joe" Mo (@yuzhoumo)
# license: GNU GPLv3

# force run as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
    $arguments = "& '" +$myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break;
}

# Windows 11 Enterprise KMS key
$enterpriseKey = "NPPR9-FWDCX-D2C8J-H872K-2YT43"
$scriptDir = Split-Path $MyInvocation.MyCommand.Path
$activator = "$scriptDir\..\..\assets\mas_aio.cmd"

Write-Host "> Setting KMS Key for Windows 11 Enterprise"
cscript C:\Windows\System32\slmgr.vbs /ipk $enterpriseKey

Write-Host "> Activating Windows"
Start-Process $activator -ArgumentList "/HWID" -Wait
