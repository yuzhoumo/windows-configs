#############################
# Remove Windows 11 Bloatware
#############################

# Force run as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
    $arguments = "& '" +$myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

@(
    "*Microsoft.Microsoft3DViewer*",             # 3D Viewer
    "*microsoft.windowscommunicationsapps*",     # Calendar & Mail
    "*Microsoft.WindowsCamera*",                 # Camera
    "*Microsoft.549981C3F5F10*",                 # Cortana
    "*Microsoft.WindowsFeedbackHub*",            # Feedback Hub
    "*Microsoft.GetHelp*",                       # Get Help
    "*Microsoft.ZuneMusic*",                     # Groove Music
    "*Microsoft.WindowsMaps*",                   # Maps
    "*Microsoft.MicrosoftSolitaireCollection*",  # Microsoft Solitaire Collection
    "*Microsoft.MixedReality.Portal*",           # Mixed Reality Portal
    "*Microsoft.ZuneVideo*",                     # Movies & TV
    "*Microsoft.MicrosoftOfficeHub*",            # Office
    "*Microsoft.Office.OneNote*",                # OneNote
    "*Microsoft.MSPaint*",                       # Paint 3D
    "*Microsoft.People*",                        # People
    "*Microsoft.Windows.Photos*",                # Photos
    "*Microsoft.SkypeApp*",                      # Skype
    "*Microsoft.MicrosoftStickyNotes*",          # Sticky Notes
    "*Microsoft.Getstarted*",                    # Tips
    "*Microsoft.WindowsSoundRecorder*",          # Voice Recorder
    "*Microsoft.BingWeather*",                   # Weather
    "*Microsoft.GamingApp*",                     # Xbox
    "*Microsoft.XboxGamingOverlay*",             # Xbox Game Bar
    "*Microsoft.YourPhone*"                      # Your Phone
 ) | ForEach-Object {
    $pkg = Get-AppxPackage $_
    if ($pkg) {
        Write-Host "> Removing Program: $($_)"
        $pkg | Remove-AppxPackage
    }
 }

Write-Host "> Removing Program: OneDrive"
if (Test-Path $env:SystemRoot\SysWOW64\OneDriveSetup.exe) {
    & $env:SystemRoot\SysWOW64\OneDriveSetup.exe /uninstall
} else {
    & $env:SystemRoot\System32\OneDriveSetup.exe /uninstall
}
