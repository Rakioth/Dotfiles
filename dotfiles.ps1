#===========================================================================
# Tweaks
#===========================================================================

# Create Restore Point

Write-Host "Creating Restore Point in case something bad happens" -ForegroundColor Yellow
Enable-ComputerRestore -Drive "$env:SYSTEMDRIVE"
Checkpoint-Computer -Description "Dotfiles" -RestorePointType "MODIFY_SETTINGS"

# Run O&O Shutup

if (!(Test-Path .\ooshutup10.cfg)) {
    Write-Host "Running O&O Shutup with Recommended Settings"
    Start-BitsTransfer -Source $downloadUri -Destination $tempPath
    curl.exe -ss "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/ooshutup10.cfg" -o ooshutup10.cfg
    curl.exe -ss "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -o OOSU10.exe
}
./OOSU10.exe ooshutup10.cfg /quiet


#===========================================================================
# Install
#===========================================================================
<#
Write-Host "Installing Apps..."

$apps = @(
    @{ id = "9N69B07TNQ5C"; options = ""; type = "-laptop" }
    @{ id = "BlenderFoundation.Blender"; options = "-v 2.83.9 ; winget install -e -h --accept-source-agreements --accept-package-agreements --id BlenderFoundation.Blender -v 2.79b"; type = "-desktop" }
    @{ id = "Canonical.Ubuntu.2204"; options = "-l D:\WSL\Ubuntu"; type = "-both" }
    @{ id = "Discord.Discord"; options = ""; type = "-both" }
    @{ id = "ElectronicArts.EADesktop"; options = ""; type = "-both" }
    @{ id = "EpicGames.EpicGamesLauncher"; options = ""; type = "-desktop" }
    @{ id = "GOG.Galaxy"; options = ""; type = "-desktop" }
    @{ id = "Git.Git"; options = ""; type = "-both" }
    @{ id = "GitHub.GitHubDesktop"; options = ""; type = "-both" }
    @{ id = "Google.AndroidStudio"; options = ""; type = "-both" }
    @{ id = "Google.Chrome"; options = ""; type = "-both" }
    @{ id = "JanDeDobbeleer.OhMyPosh"; options = ""; type = "-both" }
    @{ id = "JetBrains.IntelliJIDEA.Ultimate"; options = ""; type = "-both" }
    @{ id = "KeePassXCTeam.KeePassXC"; options = ""; type = "-both" }
    @{ id = "Klocman.BulkCrapUninstaller"; options = "-l D:\BCUninstaller"; type = "-both" }
    @{ id = "Logitech.GHUB"; options = ""; type = "-both" }
    @{ id = "M2Team.NanaZip"; options = ""; type = "-both" }
    @{ id = "Microsoft.PowerShell"; options = ""; type = "-both" }
    @{ id = "Microsoft.PowerToys"; options = ""; type = "-both" }
    @{ id = "Microsoft.VisualStudio.2022.Community"; options = ""; type = "-both" }
    @{ id = "Microsoft.VisualStudioCode"; options = ""; type = "-both" }
    @{ id = "Mp3tag.Mp3tag"; options = "-l D:\Mp3tag"; type = "-desktop" }
    @{ id = "Neovim.Neovim"; options = ""; type = "-both" }
    @{ id = "Notepad++.Notepad++"; options = ""; type = "-both" }
    @{ id = "OpenJS.NodeJS"; options = ""; type = "-both" }
    @{ id = "Oracle.VirtualBox"; options = "-l D:\VirtualBox"; type = "-both" }
    @{ id = "Python.Python.3.10"; options = ""; type = "-both" }
    @{ id = "ShareX.ShareX"; options = ""; type = "-both" }
    @{ id = "SweetScape.010Editor"; options = "-l D:\010 Editor"; type = "-both" }
    @{ id = "TechPowerUp.NVCleanstall"; options = "-l D:\NVCleanstall"; type = "-both" }
    @{ id = "Ubisoft.Connect"; options = ""; type = "-both" }
    @{ id = "Valve.Steam"; options = ""; type = "-both" }
    @{ id = "chrisant996.Clink"; options = ""; type = "-both" }
    @{ id = "qBittorrent.qBittorrent"; options = "-l D:\qBittorrent"; type = "-both" }
)

ForEach ($app in $apps) {
    if ($args[0] -eq $app.type -or $app.type -eq "-both") {
        $listApp = winget list --accept-source-agreements --exact -q $app.id
        if (![String]::Join("", $listApp).Contains($app.id)) {
            Write-Host "Installing: $( $app.id )" -ForegroundColor Green
            Invoke-Expression "winget install -e -h --accept-source-agreements --accept-package-agreements --id $( $app.id ) $( $app.options )"
        }
        else {
            Write-Host "Skipping: $( $app.id ) (Already Installed)" -ForegroundColor Yellow
        }
    }
}
#>
<#
if (-not(Get-InstalledModule -Name "7Zip4Powershell" -ErrorAction SilentlyContinue)) {
    Install-Module -Name "7Zip4Powershell" -Confirm:$false -Force
    #    Uninstall-Module -Name "7Zip4Powershell" -Force
}

function Install-Program {
    param (
        [Parameter(Mandatory = $true)][string]$ProgramSource,
        [Parameter(Mandatory = $true)][string]$ProgramType,
        [Parameter(Mandatory = $false)][string]$Link,
        [Parameter(Mandatory = $false)][string]$FilenamePattern,
        [Parameter(Mandatory = $false)][string]$PathExtract,
        [Parameter(Mandatory = $false)][string]$Password,
        [Parameter(Mandatory = $false)][string]$ArgumentList,
        [Parameter(Mandatory = $false)][bool]$InnerDirectory
    )

    if ($ProgramSource -eq "Repo") {
        $releasesUri = "https://api.github.com/repos/$Link/releases/latest"
        $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object name -like $FilenamePattern).browser_download_url
        $fileName = Split-Path -Path $downloadUri -Leaf
        $tempPath = Join-Path -Path $env:TEMP -ChildPath $fileName
        Start-BitsTransfer -Source $downloadUri -Destination $tempPath
    }
    elseif ($ProgramSource -eq "Web") {
        $tempPath = Join-Path -Path $env:TEMP -ChildPath $FilenamePattern
        Start-BitsTransfer -Source $Link -Destination $tempPath
    }

    if ($ProgramType -eq "Archive") {
        Install-Archive -PathZip $tempPath -PathExtract $PathExtract -Password $Password -InnerDirectory $InnerDirectory
    }
    elseif ($ProgramType -eq "Executable") {
        Install-Executable -PathExe $tempPath -ArgumentList $ArgumentList
    }
}

function Install-Archive {
    param (
        [string]$PathZip,
        [string]$PathExtract,
        [string]$Password,
        [bool]$InnerDirectory
    )

    if ($InnerDirectory) {
        $tempExtract = Join-Path -Path $env:TEMP -ChildPath $( (New-Guid).Guid )
        Expand-7Zip -ArchiveFileName $PathZip -TargetPath $tempExtract -Password $Password
        Move-Item -Path "$tempExtract\*" -Destination $PathExtract -Force
        Remove-Item -Path $tempExtract -Force -Recurse -ErrorAction SilentlyContinue
    }
    else {
        Expand-7Zip -ArchiveFileName $PathZip -TargetPath $PathExtract -Password $Password
    }
    Remove-Item $PathZip -Force
}

function Install-Executable {
    param (
        [string]$PathExe,
        [string]$ArgumentList
    )

    Start-Process -FilePath $PathExe -ArgumentList $ArgumentList -Wait
    Remove-Item $PathExe -Force
}

function Create-Shortcut {
    param (
        [string]$SourcePath,
        [string]$ShortcutPath
    )

    $wScriptObj = New-Object -ComObject WScript.Shell
    $shortcut = $wScriptObj.CreateShortcut($ShortcutPath)
    $shortcut.TargetPath = $SourcePath
    $shortcut.Save()
}

function DownloadFiles-Repo {
    param (
        [string]$Repo,
        [string]$Path,
        [string]$DestinationPath
    )

    $contentsUri = "https://api.github.com/repos/$Repo/contents/$Path"
    $objects = Invoke-RestMethod -Method GET -Uri $contentsUri
    $files = $objects | Where-Object type -eq "file" | Select-Object -ExpandProperty download_url
    $directories = $objects | Where-Object type -eq "dir"

    $directories | ForEach-Object {
        DownloadFiles-Repo -Repo $Repo -Path $_.path -DestinationPath "$( $DestinationPath )/$( $_.name )"
    }

    if (-not(Test-Path $DestinationPath)) {
        New-Item -Path $DestinationPath -ItemType Directory
    }

    ForEach ($file in $files) {
        $fileName = Split-Path -Path $file -Leaf
        $fileDestination = Join-Path -Path $DestinationPath -ChildPath $fileName
        $outputFilename = $fileDestination.Replace("%20", " ")
        Start-BitsTransfer -Source $file -Destination $outputFilename
    }
}

# Adobe Master Collection

if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Photoshop.exe") {
    Write-Host "Skipping: Adobe Master Collection (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "magnet:?xt=urn:btih:487dafc52e228a71b8acc6d723471b64e4625976&tr=http%3A%2F%2Fbt.piratbit.club%2Fannounce%3Fuk%3DmEIL9M3q2L&dn=Adobe%20Master%20Collection%202022%20RUS-ENG%20v11|%20piratbit.org"
    Write-Host "Installing: Adobe Master Collection" -ForegroundColor Green
    Start-Process $source
}

# Battle.net

if (Test-Path "C:\Program Files (x86)\Battle.net") {
    Write-Host "Skipping: Battle.net (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://eu.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe&id=undefined"
    Write-Host "Installing: Battle.net" -ForegroundColor Green
    Install-Program -ProgramSource "Web" -ProgramType "Executable" -Link $source -FilenamePattern "Battle.net-Setup.exe" -ArgumentList '--lang=enUS --installpath="C:\Program Files (x86)\Battle.net"'
}

# Custom Context Menu

if (Test-Path "C:\Program Files (x86)\opa") {
    Write-Host "Skipping: Custom Context Menu (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://eu.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe&id=undefined"
    Write-Host "Installing: Custom Context Menu" -ForegroundColor Green
    Install-Program -ProgramSource "Web" -ProgramType "Executable" -Link $source -FilenamePattern "Battle.net-Setup.exe" -ArgumentList '--lang=enUS --installpath="C:\Program Files (x86)\Battle.net"'
    Remove-AppxPackage -Package "35795FlorianHeidenreich.Mp3tag.ShellExtension" -AllUsers
}

# DDU

if (Test-Path "$env:USERPROFILE\Desktop\DDU") {
    Write-Host "Skipping: DDU (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://ftp.nluug.nl/pub/games/PC/guru3d/ddu/[Guru3D.com]-DDU.zip"
    Write-Host "Installing: DDU" -ForegroundColor Green
    Install-Program -ProgramSource "Web" -ProgramType "Archive" -Link $source -FilenamePattern "DDU-Setup.zip" -PathExtract "$env:USERPROFILE\Desktop\DDU" -InnerDirectory $false
    Start-Process "$env:USERPROFILE\Desktop\DDU\*.exe" -Wait
    Start-Process "$env:USERPROFILE\Desktop\DDU\DDU*\Display Driver Uninstaller.exe" -Wait
}

# Microsoft Office

if (Test-Path "C:\Program Files\Microsoft Office") {
    Write-Host "Skipping: Microsoft Office (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://fm.solewe.com/vfm-admin/vfm-downloader.php?q=0&sh=4dc91763a073efd8239ba0fa86d7a77a&share=2c37e082dc41cc59d41a43a82585beab"
    Write-Host "Installing: Microsoft Office" -ForegroundColor Green
    Set-MpPreference -DisableRealtimeMonitoring $true
    Install-Program -ProgramSource "Web" -ProgramType "Archive" -Link $source -FilenamePattern "Office-Setup.zip" -PathExtract "$env:USERPROFILE\Desktop\Office" -Password "appnee.com" -InnerDirectory $false
    Start-Process "$env:USERPROFILE\Desktop\Office\OInstall.exe" -Wait
}

# Kaspersky Security Cloud

if (Test-Path "C:\Program Files (x86)\Kaspersky Lab") {
    Write-Host "Skipping: Kaspersky Security Cloud (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://dl.filehorse.com/win/anti-virus/kaspersky-free/ks4.021.3.10.391en_25092.exe?st=eE1iZHloGW3QHO1bDuEWlg&e=1666638338&fn=ks4.021.3.10.391en_25092.exe"
    Write-Host "Installing: Kaspersky Security Cloud" -ForegroundColor Green
    Set-MpPreference -DisableRealtimeMonitoring $false
    Install-Program -ProgramSource "Web" -ProgramType "Executable" -Link $source -FilenamePattern "Kaspersky-Setup.exe" -ArgumentList '/S'
    Stop-Process -Name "ksde", "ksdeui" -Force
    Uninstall-Package -Name "Kaspersky VPN"
}

# TinyTaskPortable

if (Test-Path "D:\TinyTaskPortable") {
    Write-Host "Skipping: TinyTaskPortable (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "PortableApps/Downloads"
    Write-Host "Installing: TinyTaskPortable" -ForegroundColor Green
    Install-Program -ProgramSource "Repo" -ProgramType "Executable" -Link $source -FilenamePattern "TinyTaskPortable*" -ArgumentList '/S /DESTINATION=D:\'
}

if ($args[0] -eq "-desktop") {

# ArchiSteamFarm

if (Test-Path "D:\ArchiSteamFarm") {
    Write-Host "Skipping: ArchiSteamFarm (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "JustArchiNET/ArchiSteamFarm"
    Write-Host "Installing: ArchiSteamFarm" -ForegroundColor Green
    Install-Program -ProgramSource "Repo" -ProgramType "Archive" -Link $source -FilenamePattern "*win-x64.zip" -PathExtract "D:\ArchiSteamFarm" -InnerDirectory $false
}

# Aseprite

if (Test-Path "D:\Aseprite") {
    Write-Host "Skipping: Aseprite (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://download2267.mediafire.com/zfjvk3a91zzg/w3xthz4z7dru0fc/Aseprite.zip"
    Write-Host "Installing: Aseprite" -ForegroundColor Green
    Install-Program -ProgramSource "Web" -ProgramType "Archive" -Link $source -FilenamePattern "Aseprite-Setup.zip" -PathExtract "D:\Aseprite" -InnerDirectory $true
}

# Crowbar

if (Test-Path "D:\Modding Tools\Noesis\Crowbar.exe") {
    Write-Host "Skipping: Crowbar (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "ZeqMacaw/Crowbar"
    Write-Host "Installing: Crowbar" -ForegroundColor Green
    Install-Program -ProgramSource "Repo" -ProgramType "Archive" -Link $source -FilenamePattern "*.7z" -PathExtract "D:\Modding Tools\Noesis" -InnerDirectory $false
    Create-Shortcut -SourcePath "D:\Modding Tools\Noesis\Crowbar.exe" -ShortcutPath "D:\Modding Tools\Crowbar.lnk"
}

# Deemix

if (Test-Path "D:\Deemix") {
    Write-Host "Skipping: Deemix (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://download.deemix.app/gui/win-x64_setup-latest.exe?filename=deemix-gui%20Setup.exe"
    Write-Host "Installing: Deemix" -ForegroundColor Green
    Install-Program -ProgramSource "Web" -ProgramType "Executable" -Link $source -FilenamePattern "Deemix-Setup.exe" -ArgumentList '/S /D=D:\Deemix'
}

# Noesis

if (Test-Path "D:\Modding Tools\Noesis\Noesis64.exe") {
    Write-Host "Skipping: Noesis (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://www.richwhitehouse.com/filemirror/noesisv4466.zip"
    Write-Host "Installing: Noesis" -ForegroundColor Green
    Install-Program -ProgramSource "Web" -ProgramType "Archive" -Link $source -FilenamePattern "Noesis-Setup.zip" -PathExtract "D:\Modding Tools\Noesis" -InnerDirectory $false
    Create-Shortcut -SourcePath "D:\Modding Tools\Noesis\Noesis64.exe" -ShortcutPath "D:\Modding Tools\Noesis.lnk"
}

# Rockstar Games Launcher

if (Test-Path "C:\Program Files\Rockstar Games") {
    Write-Host "Skipping: Rockstar Games Launcher (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe"
    Write-Host "Installing: Rockstar Games Launcher" -ForegroundColor Green
    Install-Program -ProgramSource "Web" -ProgramType "Executable" -Link $source -FilenamePattern "Rockstar-Games-Launcher-Setup.exe" -ArgumentList '/S'
}

# Paint.NET

if (Test-Path "D:\Paint.NET") {
    Write-Host "Skipping: Paint.NET (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "paintdotnet/release"
    Write-Host "Installing: Paint.NET" -ForegroundColor Green
    Install-Program -ProgramSource "Repo" -ProgramType "Archive" -Link $source -FilenamePattern "*portable.x64.zip" -PathExtract "D:\Paint.NET" -InnerDirectory $false
}

}
elseif ($args[0] -eq "-laptop") {

# ThrottleStop

if (Test-Path "D:\ThrottleStop") {
    Write-Host "Skipping: ThrottleStop (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://files02.tchspt.com/temp/ThrottleStop_9.5.zip"
    Write-Host "Installing: ThrottleStop" -ForegroundColor Green
    Install-Program -ProgramSource "Web" -ProgramType "Archive" -Link $source -FilenamePattern "ThrottleStop-Setup.zip" -PathExtract "D:\ThrottleStop" -InnerDirectory $false
    Remove-Item "D:\ThrottleStop\*" -Include *.url, *.txt -Force
}

}

#>



#$ProgramData = @{
#    Aseprite = "$env:APPDATA\Aseprite"
#    Blender = "$env:APPDATA\Blender Foundation\Blender"
#    Clink = "$env:LOCALAPPDATA\clink"
#    Deemix = "$env:APPDATA\deemix"
#    ImageGlass = "$env:APPDATA\ImageGlass"
#    NotepadPlusPlus = "$env:APPDATA\Notepad++"
#    PowerShell = Split-Path $PROFILE
#}

#$ProgramInstall = @{
#ImageGlassIcons = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{15872342-C9E9-4C65-9586-35B4EFDB806B}", "InstallLocation"
#Photoshop = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Photoshop.exe", "Path"
#qBittorrent = "HKLM:\SOFTWARE\WOW6432Node\qBittorrent", "InstallLocation"
#Steam = "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam", "InstallPath"
#WallpaperEngine = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 431960", "InstallLocation"
#WinRAR = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WinRAR.exe", "Path"
#}

#ForEach ($Program in $ProgramData.Keys) {
#    try {
#        $ProgramPath = Get-Item -Path $ProgramData[$Program] -ErrorAction Stop
#        Get-ChildItem "assets\$Program" | Copy-Item -Destination $ProgramPath -Recurse -Force
#        Write-Host "$Program settings applied"
#    }
#    catch {
#        Write-Host "$Program not installed" -ForegroundColor Red
#    }
#}
#
#ForEach ($Program in $ProgramInstall.Keys) {
#    try {
#        $ProgramPath = Get-ItemPropertyValue -Path $ProgramInstall[$Program][0] -Name $ProgramInstall[$Program][1] -ErrorAction Stop
#        Get-ChildItem "assets\$Program" | Copy-Item -Destination $ProgramPath -Recurse -Force
#        Write-Host "$Program settings applied"
#    }
#    catch {
#        Write-Host "$Program not installed" -ForegroundColor Red
#    }
#}
