#===========================================================================
# Initial Setup
#===========================================================================

# - Cool Prompt

$ascii = @"

       ....                           s                 .          ..               .x+=:.
   .xH888888Hx.                      :8       oec :    @88>  x .d88"               z``    ^%
 .H8888888888888:           u.      .88      @88888    %8P    5888R                   .   <k
 888*"""?""*88888X    ...ue888b    :888ooo   8"*88%     .     '888R        .u       .@8Ned8"
'f     d8x.   ^%88k   888R Y888r -*8888888   8b.      .@88u    888R     ud8888.   .@^%8888"
'>    <88888X   '?8   888R I888>   8888     u888888> ''888E``   888R   :888'8888. x88:  ``)8b.
 ``:..:``888888>    8>  888R I888>   8888      8888R     888E    888R   d888 '88%" 8888N=*8888
        ``"*88     X   888R I888>   8888      8888P     888E    888R   8888.+"     %8"    R88
   .xHHhx.."      !  u8888cJ888   .8888Lu=   *888>     888E    888R   8888L        @8Wou 9%
  X88888888hx. ..!    "*888*P"    ^%888*     4888      888&   .888B . '8888c. .+ .888888P``
 !   "*888888888"       'Y"         'Y"      '888      R888"  ^*888%   "88888%   ``   ^"F
        ^"***"``                               88R       ""      "%       "YP'
                                              88>
                                              48
                                              '8

"@
Write-Host $ascii -ForegroundColor Magenta

# - Mode Selection

do {
    $mode = Read-Host -Prompt "Available Options [-dt | Desktop Mode] [-lt | Laptop Mode]"
} until ($mode -eq "-dt" -or $mode -eq "-lt")

# - Dependencies

winget install -e -h --accept-source-agreements --accept-package-agreements --id "qBittorrent.qBittorrent" -l "D:\qBittorrent" > $null
Start-Process "magnet:?xt=urn:btih:487dafc52e228a71b8acc6d723471b64e4625976&tr=http%3A%2F%2Fbt.piratbit.club%2Fannounce%3Fuk%3DmEIL9M3q2L&dn=Adobe%20Master%20Collection%202022%20RUS-ENG%20v11|%20piratbit.org"

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force > $null
Install-Module -Name "7Zip4Powershell" -Force > $null

Enable-WindowsOptionalFeature -Online -FeatureName "NetFx4-AdvSrvs" -All -NoRestart > $null
Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All -NoRestart > $null

Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -All -NoRestart > $null
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All -NoRestart > $null

# - Functions

function Download-Files {
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

    if (!(Test-Path $DestinationPath)) {
        New-Item -Path $DestinationPath -ItemType Directory
    }

    ForEach ($file in $files) {
        $fileName = Split-Path -Path $file -Leaf
        $fileDestination = Join-Path -Path $DestinationPath -ChildPath $fileName
        $outputFilename = $fileDestination.Replace("%20", " ")
        Start-BitsTransfer -Source $file -Destination $outputFilename
    }
}

function Download-Program {
    param (
        [string]$ProgramSource,
        [string]$Link,
        [string]$FilePattern
    )

    if ($ProgramSource -eq "Repo") {
        $releasesUri = "https://api.github.com/repos/$Link/releases/latest"
        $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object name -like $FilePattern).browser_download_url
        $fileName = Split-Path -Path $downloadUri -Leaf
        $tempPath = Join-Path -Path $env:TEMP -ChildPath $fileName
        Start-BitsTransfer -Source $downloadUri -Destination $tempPath
        return $tempPath
    }
    elseif ($ProgramSource -eq "Web") {
        $tempPath = Join-Path -Path $env:TEMP -ChildPath $FilePattern
        Start-BitsTransfer -Source $Link -Destination $tempPath
        return $tempPath
    }
}

function Install-Archive {
    param (
        [Parameter(Mandatory = $true)]
        [string]$PathZip,
        [Parameter(Mandatory = $true)]
        [string]$PathExtract,
        [Parameter(Mandatory = $false)]
        [string]$Password,
        [Parameter(Mandatory = $false)]
        [bool]$InnerDirectory = $false
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
        [Parameter(Mandatory = $true)]
        [string]$PathExe,
        [Parameter(Mandatory = $false)]
        [string]$ArgumentList
    )

    if ($PSBoundParameters.ContainsKey("ArgumentList")) {
        Start-Process -FilePath $PathExe -ArgumentList $ArgumentList -Wait
    }
    else {
        Start-Process -FilePath $PathExe -Wait
    }
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

#===========================================================================
# Tweaks
#===========================================================================

# - Create Restore Point

Write-Host "`nCreating Restore Point in Case Something Bad Happens..."
Enable-ComputerRestore -Drive "$env:SYSTEMDRIVE"
Checkpoint-Computer -Description "Dotfiles" -RestorePointType "MODIFY_SETTINGS"

# - System Tweaks

Write-Host "<Doing System Tweaks>" -ForegroundColor Yellow
if (!(Test-Path "$env:USERPROFILE\ooshutup10.cfg")) {
    Write-Host "Running O&O Shutup with Recommended Settings..." -ForegroundColor Cyan
    Start-BitsTransfer -Source "https://raw.githubusercontent.com/Rakioth/Dotfiles/main/assets/O%26O%20ShutUp/ooshutup10.cfg" -Destination "$env:USERPROFILE\ooshutup10.cfg"
    Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination "$env:USERPROFILE\OOSU10.exe"
}
Start-Process -FilePath "$env:USERPROFILE\OOSU10.exe" -ArgumentList "$env:USERPROFILE\ooshutup10.cfg /quiet" -Wait

Write-Host "Restricting Windows Update P2P only to Local Network..." -ForegroundColor Cyan
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1

Write-Host "Enabling F8 Boot Menu Options..." -ForegroundColor Cyan
bcdedit /set `{current`} bootmenupolicy Legacy > $null

Write-Host "Removing AutoLogger File and Restricting Directory..." -ForegroundColor Cyan
$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
if (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
    Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
}
icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F > $null

Write-Host "Showing File Operations Details..." -ForegroundColor Cyan
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" > $null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1

Write-Host "Stopping and Disabling Diagnostics Tracking Service..." -ForegroundColor Cyan
Stop-Service "DiagTrack" -WarningAction SilentlyContinue
Set-Service "DiagTrack" -StartupType Disabled

Write-Host "Stopping and Disabling WAP Push Service..." -ForegroundColor Cyan
Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
Set-Service "dmwappushservice" -StartupType Disabled

Write-Host "Stopping and Disabling Superfetch Service..." -ForegroundColor Cyan
Stop-Service "SysMain" -WarningAction SilentlyContinue
Set-Service "SysMain" -StartupType Disabled

Write-Host "Disabling Telemetry..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" -ErrorAction SilentlyContinue > $null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" -ErrorAction SilentlyContinue > $null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" -ErrorAction SilentlyContinue > $null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" -ErrorAction SilentlyContinue > $null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" -ErrorAction SilentlyContinue > $null
Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" -ErrorAction SilentlyContinue > $null

Write-Host "Disabling Application Suggestions..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1

Write-Host "Disabling News and Interests..." -ForegroundColor Cyan
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 0
Set-ItemProperty -Path  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2

Write-Host "Disabling Feedback..." -ForegroundColor Cyan
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force > $null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue > $null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue > $null

Write-Host "Disabling Tailored Experiences..." -ForegroundColor Cyan
if (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
    New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force > $null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1

Write-Host "Disabling Advertising ID..." -ForegroundColor Cyan
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1

Write-Host "Disabling Error Reporting..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" > $null

Write-Host "Disabling Remote Assistance..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0

Write-Host "Disabling Wi-Fi Sense..." -ForegroundColor Cyan
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Force > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0

Write-Host "Disabling Activity History..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0

Write-Host "Disabling Location Tracking..." -ForegroundColor Cyan
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0

Write-Host "Disabling Automatic Maps Updates..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0

Write-Host "Disabling Storage Sense..." -ForegroundColor Cyan
Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Recurse -ErrorAction SilentlyContinue

Write-Host "Disabling GameDVR..." -ForegroundColor Cyan
Start-BitsTransfer -Source "https://www.sordum.org/files/download/power-run/PowerRun.zip" -Destination "$env:TEMP\PowerRun.zip"
Expand-7Zip -ArchiveFileName "$env:TEMP\PowerRun.zip" -TargetPath $env:TEMP
Remove-Item -Path "$env:TEMP\PowerRun.zip" -Force
if (!(Test-Path "HKCU:\System\GameConfigStore")) {
    New-Item -Path "HKCU:\System\GameConfigStore" -Force
}
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_HonorUserFSEBehaviorMode" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_EFSEFeatureFlags" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehavior" -Type DWord -Value 2
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0
& $env:TEMP\PowerRun\PowerRun.exe /SW:0 Powershell.exe -command { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" -Name "ActivationType" -Type DWord -Value 0 }
Remove-Item -Path "$env:TEMP\PowerRun" -Force -Recurse -ErrorAction SilentlyContinue

Write-Host "Doing Security Checks for Administrator Account and Group Policy" -ForegroundColor Cyan
if (($( Get-WMIObject -class Win32_ComputerSystem | Select-Object username ).username).IndexOf('Administrator') -eq -1) {
    net user administrator /active:no > $null
}

# - Performance Tweaks and More Telemetry

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Type DWord -Value 10

# - Timeout Tweaks cause Flickering on Windows Now

Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "LowLevelHooksTimeout" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillServiceTimeout" -ErrorAction SilentlyContinue

# - Network Tweaks

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "IRPStackSize" -Type DWord -Value 20
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 4294967295

# - Gaming Tweaks

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Type DWord -Value 8
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Type DWord -Value 6
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Type String -Value "High"

# - Group svchost.exe Processes

$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force

# - Miscellaneous Tweaks

Write-Host "Hiding Task View Button..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0

Write-Host "Hiding People Icon..." -ForegroundColor Cyan
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" > $null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0

Write-Host "Hiding 3D Objects Icon from This PC..." -ForegroundColor Cyan
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

Write-Host "Changing Default Explorer View to This PC..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

Write-Host "Enabling NumLock after Startup..." -ForegroundColor Cyan
if (!(Test-Path "HKU:")) {
    New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS > $null
}
Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2

Write-Host "Disabling Notifications and Action Center..." -ForegroundColor Cyan
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "Explorer" -Force > $null
New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -PropertyType "DWord" -Value 1 > $null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -PropertyType "DWord" -Value 0 -force > $null

if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force > $null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAMeetNow" -Type DWord -Value 1

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Type DWORD -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1

# - Set Services to Manual

Write-Host "`n<Setting Services to Manual>" -ForegroundColor Yellow

$services = @(
"ALG"                                          # Application Layer Gateway Service(Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
"AJRouter"                                     # Needed for AllJoyn Router Service
"BcastDVRUserService_48486de"                  # GameDVR and Broadcast is used for Game Recordings and Live Broadcasts
"Browser"                                      # Let users browse and locate shared resources in neighboring computers
"BthAvctpSvc"                                  # AVCTP service (needed for Bluetooth Audio Devices or Wireless Headphones)
"CaptureService_48486de"                       # Optional screen capture functionality for applications that call the Windows.Graphics.Capture API.
"cbdhsvc_48486de"                              # Clipboard Service
"diagnosticshub.standardcollector.service"     # Microsoft (R) Diagnostics Hub Standard Collector Service
"DiagTrack"                                    # Diagnostics Tracking Service
"dmwappushservice"                             # WAP Push Message Routing Service
"DPS"                                          # Diagnostic Policy Service (Detects and Troubleshoots Potential Problems)
"edgeupdate"                                   # Edge Update Service
"edgeupdatem"                                  # Another Update Service
"Fax"                                          # Fax Service
"fhsvc"                                        # Fax History
"FontCache"                                    # Windows font cache
"gupdate"                                      # Google Update
"gupdatem"                                     # Another Google Update Service
"lfsvc"                                        # Geolocation Service
"lmhosts"                                      # TCP/IP NetBIOS Helper
"MapsBroker"                                   # Downloaded Maps Manager
"MicrosoftEdgeElevationService"                # Another Edge Update Service
"MSDTC"                                        # Distributed Transaction Coordinator
"NahimicService"                               # Nahimic Service
"NetTcpPortSharing"                            # Net.Tcp Port Sharing Service
"PcaSvc"                                       # Program Compatibility Assistant Service
"PerfHost"                                     # Remote users and 64-bit processes to query performance.
"PhoneSvc"                                     # Phone Service(Manages the telephony state on the device)
"PrintNotify"                                  # Windows printer notifications and extentions
"QWAVE"                                        # Quality Windows Audio Video Experience (audio and video might sound worse)
"RemoteAccess"                                 # Routing and Remote Access
"RemoteRegistry"                               # Remote Registry
"RetailDemo"                                   # Demo Mode for Store Display
"RtkBtManServ"                                 # Realtek Bluetooth Device Manager Service
"SCardSvr"                                     # Windows Smart Card Service
"seclogon"                                     # Secondary Logon (Disables other credentials only password will work)
"SEMgrSvc"                                     # Payments and NFC/SE Manager (Manages payments and Near Field Communication (NFC) based secure elements)
"SharedAccess"                                 # Internet Connection Sharing (ICS)
"stisvc"                                       # Windows Image Acquisition (WIA)
"SysMain"                                      # Analyses System Usage and Improves Performance
"TrkWks"                                       # Distributed Link Tracking Client
"WbioSrvc"                                     # Windows Biometric Service (required for Fingerprint reader / facial detection)
"WerSvc"                                       # Windows error reporting
"wisvc"                                        # Windows Insider program(Windows Insider will not work if Disabled)
"WMPNetworkSvc"                                # Windows Media Player Network Sharing Service
"WpcMonSvc"                                    # Parental Controls
"WPDBusEnum"                                   # Portable Device Enumerator Service
"WpnService"                                   # WpnService (Push Notifications may not work)
"wscsvc"                                       # Windows Security Center Service
"WSearch"                                      # Windows Search
"XblAuthManager"                               # Xbox Live Auth Manager (Disabling Breaks Xbox Live Games)
"XblGameSave"                                  # Xbox Live Game Save Service (Disabling Breaks Xbox Live Games)
"XboxNetApiSvc"                                # Xbox Live Networking Service (Disabling Breaks Xbox Live Games)
"XboxGipSvc"                                   # Xbox Accessory Management Service
# HP Services
"HPAppHelperCap"
"HPDiagsCap"
"HPNetworkCap"
"HPSysInfoCap"
"HpTouchpointAnalyticsService"
# Hyper-V Services
"HvHost"
"vmicguestinterface"
"vmicheartbeat"
"vmickvpexchange"
"vmicrdv"
"vmicshutdown"
"vmictimesync"
"vmicvmsession"
)

ForEach ($service in $services) {
    Write-Host "Setting: $service StartupType to Manual" -ForegroundColor Cyan
    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Manual -ErrorAction SilentlyContinue > $null
}

# - Remove ALL MS Store Apps

Write-Host "`n<Removing Bloatware Apps>" -ForegroundColor Yellow

$bloatware = @(
"3DBuilder"
"Microsoft3DViewer"
"AppConnector"
"BingFinance"
"BingNews"
"BingSports"
"BingTranslator"
"BingWeather"
"BingFoodAndDrink"
"BingHealthAndFitness"
"BingTravel"
"MinecraftUWP"
"GamingServices"
"WindowsReadingList"
"GetHelp"
"Getstarted"
"Messaging"
"Microsoft3DViewer"
"MicrosoftSolitaireCollection"
"NetworkSpeedTest"
"News"
"Lens"
"Sway"
"OneNote"
"OneConnect"
"People"
"Print3D"
"RemoteDesktop"
"SkypeApp"
"Todos"
"Wallet"
"Whiteboard"
"WindowsAlarms"
"windowscommunicationsapps"
"WindowsFeedbackHub"
"WindowsMaps"
"WindowsPhone"
"WindowsSoundRecorder"
"XboxApp"
"ConnectivityStore"
"CommsPhone"
"ScreenSketch"
"TCUI"
"XboxGameOverlay"
"XboxGameCallableUI"
"XboxSpeechToTextOverlay"
"MixedReality.Portal"
"ZuneMusic"
"ZuneVideo"
"YourPhone"
"Getstarted"
"MicrosoftOfficeHub"
"EclipseManager"
"ActiproSoftwareLLC"
"AdobeSystemsIncorporated.AdobePhotoshopExpress"
"Duolingo-LearnLanguagesforFree"
"PandoraMediaInc"
"CandyCrush"
"BubbleWitch3Saga"
"Wunderlist"
"Flipboard"
"Twitter"
"Facebook"
"Royal Revolt"
"Speed Test"
"Dolby"
"Viber"
"ACGMediaPlayer"
"Netflix"
"OneCalendar"
"LinkedInforWindows"
"HiddenCityMysteryofShadows"
"Hulu"
"HiddenCity"
"AdobePhotoshopExpress"
"HotspotShieldFreeVPN"
"Advertising"
"MSPaint"
"Paint"
"QuickAssist"
"MicrosoftStickyNotes"
"HPJumpStarts"
"HPPCHardwareDiagnosticsWindows"
"HPPowerManager"
"HPPrivacySettings"
"HPSupportAssistant"
"HPSureShieldAI"
"HPSystemInformation"
"HPQuickDrop"
"HPWorkWell"
"myHP"
"HPDesktopSupportUtilities"
"HPQuickTouch"
"HPEasyClean"
"HPSystemInformation"
)

ForEach ($bloat in $bloatware) {
    Get-AppxPackage "*$Bloat*" | Remove-AppxPackage -ErrorAction SilentlyContinue > $null
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$Bloat*" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue > $null
    Write-Host "Removing $Bloat" -ForegroundColor Cyan
}

Write-Host "`n<Removing Bloatware Programs>" -ForegroundColor Yellow
$InstalledPrograms = Get-Package | Where-Object { $UninstallPrograms -contains $_.Name }

$InstalledPrograms | ForEach-Object {
    Write-Host -Object "Attempting to Uninstall: [$( $_.Name )]..." -ForegroundColor Yellow
    try {
        $Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction SilentlyContinue
        Write-Host -Object "Successfully Uninstalled: [$( $_.Name )]" -ForegroundColor Cyan
    }
    catch {
        Write-Warning -Message "Failed to Uninstall: [$( $_.Name )]"
    }
}

Write-Host "Removing: Cortana" -ForegroundColor Cyan
Get-AppxPackage -AllUsers Microsoft.549981C3F5F10 | Remove-AppxPackage

Write-Host "Removing: Microsoft Edge" -ForegroundColor Cyan
Invoke-WebRequest -useb https://raw.githubusercontent.com/Rakioth/Dotfiles/main/assets/O%26O%20ShutUp/Edge_Removal.bat | Invoke-Expression

Write-Host "Removing: Microsoft Teams" -ForegroundColor Cyan
function getUninstallString($match) {
    return (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -like "*$match*" }).UninstallString
}
$TeamsPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'Microsoft', 'Teams')
$TeamsUpdateExePath = [System.IO.Path]::Combine($TeamsPath, 'Update.exe')
Stop-Process -Name "*teams*" -Force -ErrorAction SilentlyContinue

if ( [System.IO.File]::Exists($TeamsUpdateExePath)) {
    $proc = Start-Process $TeamsUpdateExePath "-uninstall -s" -PassThru
    $proc.WaitForExit()
}
Get-AppxPackage "*Teams*" | Remove-AppxPackage -ErrorAction SilentlyContinue
Get-AppxPackage "*Teams*" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue

if ( [System.IO.Directory]::Exists($TeamsPath)) {
    Remove-Item $TeamsPath -Force -Recurse -ErrorAction SilentlyContinue
}
$us = getUninstallString("Teams");
if ($us.Length -gt 0) {
    $us = ($us.Replace("/I", "/uninstall ") + " /quiet").Replace("  ", " ")
    $FilePath = ($us.Substring(0, $us.IndexOf(".exe") + 4).Trim())
    $ProcessArgs = ($us.Substring($us.IndexOf(".exe") + 5).Trim().replace("  ", " "))
    $proc = Start-Process -FilePath $FilePath -Args $ProcessArgs -PassThru
    $proc.WaitForExit()
}

if ($mode -eq "-dt") {

# - Disable Hibernation

Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernateEnabled" -Type Dword -Value 0
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 0

# - Disable Power Throttling

if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling") {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Type DWord -Value 00000001
}
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 0000000

}
elseif ($mode -eq "-lt") {

# - Enable Power Throttling

if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling") {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Type DWord -Value 00000000
}
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 0000001

}

# - Fix Windows Update Scheme

Write-Host "`n<Rescheduling Windows Updates>" -ForegroundColor Yellow

Write-Host "Disabling Driver Offering through Windows Update..." -ForegroundColor Cyan
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Force > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value 1
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Force > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontPromptForWindowsUpdate" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontSearchWindowsUpdate" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DriverUpdateWizardWuSearchEnabled" -Type DWord -Value 0
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Type DWord -Value 1

Write-Host "Disabling Windows Update Automatic Restart..." -ForegroundColor Cyan
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force > $null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "BranchReadinessLevel" -Type DWord -Value 20
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "DeferFeatureUpdatesPeriodInDays" -Type DWord -Value 365
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "DeferQualityUpdatesPeriodInDays " -Type DWord -Value 4

Write-Host "`n=================================" -ForegroundColor Green
Write-Host "---      Tweaks Applied       ---" -ForegroundColor Green
Write-Host "=================================`n" -ForegroundColor Green

#===========================================================================
# Install
#===========================================================================

Write-Host "<Installing Winget Apps>" -ForegroundColor Yellow

$apps = @(
@{ id = "9N69B07TNQ5C"; options = ""; type = "-lt" }
@{ id = "BlenderFoundation.Blender"; options = "-v 2.83.9 ; winget install -e -h --accept-source-agreements --accept-package-agreements --id BlenderFoundation.Blender -v 2.79b"; type = "-dt" }
@{ id = "Discord.Discord"; options = ""; type = "-both" }
@{ id = "ElectronicArts.EADesktop"; options = ""; type = "-both" }
@{ id = "EpicGames.EpicGamesLauncher"; options = ""; type = "-dt" }
@{ id = "GOG.Galaxy"; options = ""; type = "-dt" }
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
@{ id = "Mp3tag.Mp3tag"; options = "-l D:\Mp3tag"; type = "-dt" }
@{ id = "Neovim.Neovim"; options = ""; type = "-both" }
@{ id = "OpenJS.NodeJS"; options = ""; type = "-both" }
@{ id = "Oracle.VirtualBox"; options = "-l D:\VirtualBox"; type = "-both" }
@{ id = "Python.Python.3.10"; options = ""; type = "-both" }
@{ id = "SweetScape.010Editor"; options = "-l D:\010 Editor"; type = "-both" }
@{ id = "TechPowerUp.NVCleanstall"; options = "-l D:\NVCleanstall"; type = "-both" }
@{ id = "Ubisoft.Connect"; options = ""; type = "-both" }
@{ id = "Valve.Steam"; options = ""; type = "-both" }
@{ id = "chrisant996.Clink"; options = ""; type = "-both" }
)

ForEach ($app in $apps) {
    if ($mode -eq $app.type -or $app.type -eq "-both") {
        $listApp = winget list --accept-source-agreements --exact -q $app.id
        if (![String]::Join("", $listApp).Contains($app.id)) {
            Write-Host "Installing: $( $app.id )" -ForegroundColor Cyan
            Invoke-Expression "winget install -e -h --accept-source-agreements --accept-package-agreements --id $( $app.id ) $( $app.options )"
        }
        else {
            Write-Host "Skipping: $( $app.id ) (Already Installed)" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n<Installing External Apps>" -ForegroundColor Yellow

# - Adobe Master Collection

if (Test-Path "D:\Adobe\Adobe Photoshop 2022") {
    Write-Host "Skipping: Adobe Master Collection (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "$env:USERPROFILE\Downloads\Master.Collection.2022\Adobe.Master.Collection.2022.v11.RU-EN.iso"
    Write-Host "Installing: Adobe Master Collection" -ForegroundColor Cyan
    Mount-DiskImage $source > $null
    Start-Process "E:\Adobe 2022\Set-up.exe" -Wait
    Dismount-DiskImage $source > $null
    Stop-Process -Name "qbittorrent" -Force -ErrorAction SilentlyContinue
    Wait-Process -Name "qbittorrent" -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:USERPROFILE\Downloads\Master.Collection.2022" -Force -Recurse -ErrorAction SilentlyContinue
}

# - Arch WSL

if (Test-Path "C:\Program Files\WindowsApps\yuk7.archwsl*") {
    Write-Host "Skipping: Arch WSL (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "yuk7/ArchWSL"
    Write-Host "Installing: Arch WSL" -ForegroundColor Cyan
    Write-Host "Select <Local Machine> and Place Certificate in <Trusted People>" -ForegroundColor Yellow
    $certificatePath = Download-Program -ProgramSource "Repo" -Link $source -FilePattern "ArchWSL-AppX*.cer"
    Install-Executable -PathExe $certificatePath
    $programPath = Download-Program -ProgramSource "Repo" -Link $source -FilePattern "ArchWSL-AppX*.appx"
    Add-AppxPackage $programPath
    Remove-Item $programPath -Force
    Start-Process "C:\Program Files\WindowsApps\yuk7.archwsl*\Arch.exe" -Wait
}

# - Battle.net

if (Test-Path "C:\Program Files (x86)\Battle.net") {
    Write-Host "Skipping: Battle.net (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://eu.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe&id=undefined"
    Write-Host "Installing: Battle.net" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Web" -Link $source -FilePattern "Battle.net-Setup.exe"
    Install-Executable -PathExe $programPath -ArgumentList '--lang=enUS --installpath="C:\Program Files (x86)\Battle.net"'
}

# - Microsoft Office

if (Test-Path "C:\Program Files\Microsoft Office") {
    Write-Host "Skipping: Microsoft Office (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://fm.solewe.com/vfm-admin/vfm-downloader.php?q=0&sh=4dc91763a073efd8239ba0fa86d7a77a&share=2c37e082dc41cc59d41a43a82585beab"
    Write-Host "Installing: Microsoft Office" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Web" -Link $source -FilePattern "Office-Setup.zip"
    Install-Archive -PathZip $programPath -PathExtract "$env:USERPROFILE\Desktop\Office" -Password "appnee.com"
    Start-Process "$env:USERPROFILE\Desktop\Office\OInstall.exe" -Wait
    Remove-Item -Path "$env:USERPROFILE\Desktop\Office" -Force -Recurse -ErrorAction SilentlyContinue
}

# - Kaspersky Security Cloud

if (Test-Path "C:\Program Files (x86)\Kaspersky Lab") {
    Write-Host "Skipping: Kaspersky Security Cloud (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://www.filehorse.com/download/file/5pDnC3wO8B5VYavv4AVlKW-68N-SLZfvO2A3q3-jdo_-koosgLeX2i-RLB6zFRxRO3aio1fBZcvsNjsodfQJ1_MNP2e5dPBSwHet3e3I4AM"
    Write-Host "Installing: Kaspersky Security Cloud" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Web" -Link $source -FilePattern "Kaspersky-Setup.exe"
    Install-Executable -PathExe $programPath
    Stop-Process -Name "ksde", "ksdeui" -Force -ErrorAction SilentlyContinue
    Wait-Process -Name "ksde", "ksdeui" -ErrorAction SilentlyContinue
    Uninstall-Package -Name "Kaspersky VPN"
}

# - TinyTaskPortable

if (Test-Path "D:\TinyTaskPortable") {
    Write-Host "Skipping: TinyTaskPortable (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "PortableApps/Downloads"
    Write-Host "Installing: TinyTaskPortable" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Repo" -Link $source -FilePattern "TinyTaskPortable*"
    Install-Executable -PathExe $programPath -ArgumentList '/S /DESTINATION=D:\'
}

if ($mode -eq "-dt") {

# - ArchiSteamFarm

if (Test-Path "D:\ArchiSteamFarm") {
    Write-Host "Skipping: ArchiSteamFarm (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "JustArchiNET/ArchiSteamFarm"
    Write-Host "Installing: ArchiSteamFarm" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Repo" -Link $source -FilePattern "*win-x64.zip"
    Install-Archive -PathZip $programPath -PathExtract "D:\ArchiSteamFarm"
}

# - Aseprite

if (Test-Path "D:\Aseprite") {
    Write-Host "Skipping: Aseprite (Already Installed)" -ForegroundColor Yellow
}
else {
#    $source = "https://download2267.mediafire.com/zfjvk3a91zzg/w3xthz4z7dru0fc/Aseprite.zip"
    $source = "https://drive.google.com/u/0/uc?id=10RclaGRFYjVbRL-fK8pkWXx2rPVN7o4A&export=download&confirm=t&uuid=3ec60e51-0305-4b10-9488-6cf9660e492c&at=ALAFpqySx4Uflwod0L97byzkeJjw:1667205381457"
    Write-Host "Installing: Aseprite" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Web" -Link $source -FilePattern "Aseprite-Setup.zip"
    Install-Archive -PathZip $programPath -PathExtract "D:\Aseprite" -InnerDirectory $true
}

# - Crowbar

if (Test-Path "D:\Modding Tools\Noesis\Crowbar.exe") {
    Write-Host "Skipping: Crowbar (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "ZeqMacaw/Crowbar"
    Write-Host "Installing: Crowbar" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Repo" -Link $source -FilePattern "*.7z"
    Install-Archive -PathZip $programPath -PathExtract "D:\Modding Tools\Noesis"
    Create-Shortcut -SourcePath "D:\Modding Tools\Noesis\Crowbar.exe" -ShortcutPath "D:\Modding Tools\Crowbar.lnk"
}

# - Deemix

if (Test-Path "D:\Deemix") {
    Write-Host "Skipping: Deemix (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://download.deemix.app/gui/win-x64_setup-latest.exe?filename=deemix-gui%20Setup.exe"
    Write-Host "Installing: Deemix" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Web" -Link $source -FilePattern "Deemix-Setup.exe"
    Install-Executable -PathExe $programPath -ArgumentList '/S /D=D:\Deemix'
}

# - Noesis

if (Test-Path "D:\Modding Tools\Noesis\Noesis64.exe") {
    Write-Host "Skipping: Noesis (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://www.richwhitehouse.com/filemirror/noesisv4466.zip"
    Write-Host "Installing: Noesis" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Web" -Link $source -FilePattern "Noesis-Setup.zip"
    Install-Archive -PathZip $programPath -PathExtract "D:\Modding Tools\Noesis"
    Create-Shortcut -SourcePath "D:\Modding Tools\Noesis\Noesis64.exe" -ShortcutPath "D:\Modding Tools\Noesis.lnk"
}

# - Rockstar Games Launcher

if (Test-Path "C:\Program Files\Rockstar Games") {
    Write-Host "Skipping: Rockstar Games Launcher (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe"
    Write-Host "Installing: Rockstar Games Launcher" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Web" -Link $source -FilePattern "Rockstar-Games-Launcher-Setup.exe"
    Install-Executable -PathExe $programPath
}

# - Paint.NET

if (Test-Path "D:\Paint.NET") {
    Write-Host "Skipping: Paint.NET (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "paintdotnet/release"
    Write-Host "Installing: Paint.NET" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Repo" -Link $source -FilePattern "*portable.x64.zip"
    Install-Archive -PathZip $programPath -PathExtract "D:\Paint.NET"
}

}
elseif ($mode -eq "-lt") {

# - ThrottleStop

if (Test-Path "D:\ThrottleStop") {
    Write-Host "Skipping: ThrottleStop (Already Installed)" -ForegroundColor Yellow
}
else {
    $source = "https://files02.tchspt.com/temp/ThrottleStop_9.5.zip"
    Write-Host "Installing: ThrottleStop" -ForegroundColor Cyan
    $programPath = Download-Program -ProgramSource "Web" -Link $source -FilePattern "ThrottleStop-Setup.zip"
    Install-Archive -PathZip $programPath -PathExtract "D:\ThrottleStop"
    Remove-Item "D:\ThrottleStop\*" -Include *.url, *.txt -Force
}

}

Write-Host "`n=================================" -ForegroundColor Green
Write-Host "---      Apps Installed       ---" -ForegroundColor Green
Write-Host "=================================`n" -ForegroundColor Green

#===========================================================================
# Settings
#===========================================================================

<#

Write-Host "Applying Settings..."

$programData = @(
@{ asset = "assets/Aseprite"; location = "$env:APPDATA\Aseprite"; type = "-dt" }
@{ asset = "assets/Blender"; location = "C:\Program Files\Blender Foundation\Blender\2.79\scripts"; type = "-dt" }
@{ asset = "assets/Clink"; location = "$env:LOCALAPPDATA\clink"; type = "-both" }
@{ asset = "assets/Deemix"; location = "$env:APPDATA\deemix"; type = "-dt" } #Open Deemix
@{ asset = "assets/Dotfiles"; location = "D:\Dotfiles"; type = "-both" }
@{ asset = "assets/IntelliJ"; location = "$env:APPDATA\deemix"; type = "-both" }
@{ asset = "assets/Mp3tag"; location = "$env:APPDATA\deemix"; type = "-dt" }
@{ asset = "assets/Photoshop"; location = "D:\Adobe\Adobe Photoshop 2022\Required"; type = "-both" }
@{ asset = "assets/PowerShell"; location = $PROFILE; type = "-both" }
@{ asset = "assets/qBittorrent"; location = $PROFILE; type = "-both" }
@{ asset = "assets/Steam"; location = $PROFILE; type = "-both" }
@{ asset = "assets/SweetScape"; location = $PROFILE; type = "-both" }
@{ asset = "assets/Terminal"; location = $PROFILE; type = "-both" }
@{ asset = "assets/Visual Studio"; location = $PROFILE; type = "-both" }
@{ asset = "assets/Wallpaper Engine"; location = $PROFILE; type = "-both" }
)

ForEach ($data in $programData) {
    if ($mode -eq $data.type -or $data.type -eq "-both") {
        Write-Host "Applying Settings to: $( $data.asset.Replace("assets/", ""))" -ForegroundColor Green
        DownloadFiles-Repo -Repo "Rakioth/Dotfiles" -Path $data.asset -DestinationPath $data.location
    }
}



## Delete Temporary Files
#Write-Host "Delete Temp Files"
#Get-ChildItem -Path "C:\Windows\Temp" *.* -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
#Get-ChildItem -Path $env:TEMP *.* -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

## Run Disk Cleanup
#Write-Host "Running Disk Cleanup on Drive C:..."
#cmd /c cleanmgr.exe /d C: /VERYLOWDISK

Remove-AppxPackage -Package "35795FlorianHeidenreich.Mp3tag.ShellExtension" -AllUsers

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

#>
