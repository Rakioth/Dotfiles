#===========================================================================
# Tweaks
#===========================================================================
<#
# Create Restore Point

Write-Host "Creating Restore Point in case something bad happens"
Enable-ComputerRestore -Drive "$env:SYSTEMDRIVE"
Checkpoint-Computer -Description "Dotfiles" -RestorePointType "MODIFY_SETTINGS"

# Run O&O Shutup

if (!(Test-Path .\ooshutup10.cfg)) {
    Write-Host "Running O&O Shutup with Recommended Settings"
    Start-BitsTransfer -Source "https://raw.githubusercontent.com/Rakioth/Dotfiles/main/assets/O%26O%20ShutUp/ooshutup10.cfg" -Destination "$env:USERPROFILE\ooshutup10.cfg"
    Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination "$env:USERPROFILE\OOSU10.exe"
}
Start-Process -FilePath "$env:USERPROFILE\OOSU10.exe" -ArgumentList "$env:USERPROFILE\ooshutup10.cfg /quiet" -Wait

# Disable Telemetry

Write-Host "Disabling Telemetry..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null

Write-Host "Disabling Application Suggestions..."
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
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1

Write-Host "Disabling Feedback..."
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null

Write-Host "Disabling Tailored Experiences..."
if (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
    New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1

Write-Host "Disabling Advertising ID..."
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1

Write-Host "Disabling Error Reporting..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null

Write-Host "Restricting Windows Update P2P only to Local Network..."
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1

Write-Host "Stopping and Disabling Diagnostics Tracking Service..."
Stop-Service "DiagTrack" -WarningAction SilentlyContinue
Set-Service "DiagTrack" -StartupType Disabled

Write-Host "Stopping and Disabling WAP Push Service..."
Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
Set-Service "dmwappushservice" -StartupType Disabled

Write-Host "Enabling F8 Boot Menu Options..."
bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null

Write-Host "Disabling Remote Assistance..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0

Write-Host "Stopping and Disabling Superfetch Service..."
Stop-Service "SysMain" -WarningAction SilentlyContinue
Set-Service "SysMain" -StartupType Disabled

Write-Host "Showing File Operations Details..."
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1

Write-Host "Hiding Task View Button..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0

Write-Host "Hiding People Icon..."
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0

Write-Host "Changing Default Explorer View to This PC..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

# Enable Long Paths

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Type DWORD -Value 1
Write-Host "Hiding 3D Objects Icon from This PC..."
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

# Performance Tweaks and More Telemetry

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Type DWord -Value 10

# Timeout Tweaks cause flickering on Windows now

Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "LowLevelHooksTimeout" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillServiceTimeout" -ErrorAction SilentlyContinue

# Network Tweaks

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "IRPStackSize" -Type DWord -Value 20
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 4294967295

# Gaming Tweaks

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Type DWord -Value 8
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Type DWord -Value 6
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Type String -Value "High"

# Group svchost.exe Processes

$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force

Write-Host "Disable News and Interests"
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 0

# Remove "News and Interest" from Taskbar

Set-ItemProperty -Path  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2

# Remove "Meet Now" Button from Taskbar

if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAMeetNow" -Type DWord -Value 1

Write-Host "Removing AutoLogger File and Restricting Directory..."
$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
if (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
    Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
}
icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

Write-Host "Stopping and Disabling Diagnostics Tracking Service..."
Stop-Service "DiagTrack"
Set-Service "DiagTrack" -StartupType Disabled
Write-Host "Doing Security checks for Administrator Account and Group Policy"
if (($( Get-WMIObject -class Win32_ComputerSystem | Select-Object username ).username).IndexOf('Administrator') -eq -1) {
    net user administrator /active:no
}

# Disable Wi-Fi Sense

Write-Host "Disabling Wi-Fi Sense..."
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0

# Disable Activity History

Write-Host "Disabling Activity History..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0

# Disable Location Tracking

Write-Host "Disabling Location Tracking..."
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
Write-Host "Disabling Automatic Maps Updates..."
Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0

# Disable Storage Sense

Write-Host "Disabling Storage Sense..."
Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Recurse -ErrorAction SilentlyContinue

# Disable GameDVR

# Set Services to Manual

$services = @(
"ALG"                                          # Application Layer Gateway Service(Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
"AJRouter"                                     # Needed for AllJoyn Router Service
"BcastDVRUserService_48486de"                  # GameDVR and Broadcast is used for Game Recordings and Live Broadcasts
#"BDESVC"                                      # Bitlocker Drive Encryption Service
#"BFE"                                         # Base Filtering Engine (Manages Firewall and Internet Protocol security)
#"BluetoothUserService_48486de"                # Bluetooth user service supports proper functionality of Bluetooth features relevant to each user session.
#"BrokerInfrastructure"                        # Windows Infrastructure Service (Controls which background tasks can run on the system)
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
#"EntAppSvc"                                   # Enterprise Application Management.
"Fax"                                          # Fax Service
"fhsvc"                                        # Fax History
"FontCache"                                    # Windows font cache
#"FrameServer"                                 # Windows Camera Frame Server (Allows multiple clients to access video frames from camera devices)
"gupdate"                                      # Google Update
"gupdatem"                                     # Another Google Update Service
#"iphlpsvc"                                    # ipv6(Most websites use ipv4 instead) - Needed for Xbox Live
"lfsvc"                                        # Geolocation Service
#"LicenseManager"                              # Disable LicenseManager (Windows Store may not work properly)
"lmhosts"                                      # TCP/IP NetBIOS Helper
"MapsBroker"                                   # Downloaded Maps Manager
"MicrosoftEdgeElevationService"                # Another Edge Update Service
"MSDTC"                                        # Distributed Transaction Coordinator
"NahimicService"                               # Nahimic Service
#"ndu"                                         # Windows Network Data Usage Monitor (Disabling Breaks Task Manager Per-Process Network Monitoring)
"NetTcpPortSharing"                            # Net.Tcp Port Sharing Service
"PcaSvc"                                       # Program Compatibility Assistant Service
"PerfHost"                                     # Remote users and 64-bit processes to query performance.
"PhoneSvc"                                     # Phone Service(Manages the telephony state on the device)
#"PNRPsvc"                                     # Peer Name Resolution Protocol (Some peer-to-peer and collaborative applications, such as Remote Assistance, may not function, Discord will still work)
#"p2psvc"                                      # Peer Name Resolution Protocol(Enables multi-party communication using Peer-to-Peer Grouping.  If disabled, some applications, such as HomeGroup, may not function. Discord will still work)iscord will still work)
#"p2pimsvc"                                    # Peer Networking Identity Manager (Peer-to-Peer Grouping services may not function, and some applications, such as HomeGroup and Remote Assistance, may not function correctly. Discord will still work)
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
#"Spooler"                                     # Printing
"stisvc"                                       # Windows Image Acquisition (WIA)
#"StorSvc"                                     # StorSvc (usb external hard drive will not be reconized by windows)
"SysMain"                                      # Analyses System Usage and Improves Performance
"TrkWks"                                       # Distributed Link Tracking Client
#"WbioSrvc"                                    # Windows Biometric Service (required for Fingerprint reader / facial detection)
"WerSvc"                                       # Windows error reporting
"wisvc"                                        # Windows Insider program(Windows Insider will not work if Disabled)
#"WlanSvc"                                     # WLAN AutoConfig
"WMPNetworkSvc"                                # Windows Media Player Network Sharing Service
"WpcMonSvc"                                    # Parental Controls
"WPDBusEnum"                                   # Portable Device Enumerator Service
"WpnService"                                   # WpnService (Push Notifications may not work)
#"wscsvc"                                      # Windows Security Center Service
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
    Write-Host "Setting $service StartupType to Manual"
    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Manual -ErrorAction SilentlyContinue
}

# Enable NumLock on Startup

Write-Host "Enabling NumLock after Startup..."
if (!(Test-Path "HKU:")) {
    New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
}
Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2

# Show File Extensions

Write-Host "Showing Known File Extensions..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0

# Disable Notifications

Write-Host "Disabling Notifications and Action Center..."
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "Explorer" -force
New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -PropertyType "DWord" -Value 1
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -PropertyType "DWord" -Value 0 -force

# Remove ALL MS Store Apps

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

function getUninstallString($match) {
    return (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -like "*$match*" }).UninstallString
}
$TeamsPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'Microsoft', 'Teams')
$TeamsUpdateExePath = [System.IO.Path]::Combine($TeamsPath, 'Update.exe')

Write-Host "Stopping Teams Process..."
Stop-Process -Name "*teams*" -Force -ErrorAction SilentlyContinue

Write-Host "Uninstalling Teams from AppData\Microsoft\Teams"
if ( [System.IO.File]::Exists($TeamsUpdateExePath)) {
    $proc = Start-Process $TeamsUpdateExePath "-uninstall -s" -PassThru
    $proc.WaitForExit()
}

Write-Host "Removing Teams AppxPackage..."
Get-AppxPackage "*Teams*" | Remove-AppxPackage -ErrorAction SilentlyContinue
Get-AppxPackage "*Teams*" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue

Write-Host "Deleting Teams Directory"
if ( [System.IO.Directory]::Exists($TeamsPath)) {
    Remove-Item $TeamsPath -Force -Recurse -ErrorAction SilentlyContinue
}

Write-Host "Deleting Teams Uninstall Registry Key"
$us = getUninstallString("Teams");
if ($us.Length -gt 0) {
    $us = ($us.Replace("/I", "/uninstall ") + " /quiet").Replace("  ", " ")
    $FilePath = ($us.Substring(0, $us.IndexOf(".exe") + 4).Trim())
    $ProcessArgs = ($us.Substring($us.IndexOf(".exe") + 5).Trim().replace("  ", " "))
    $proc = Start-Process -FilePath $FilePath -Args $ProcessArgs -PassThru
    $proc.WaitForExit()
}
Write-Host "Restart Computer to Complete Teams Uninstall"

Write-Host "Removing Bloatware Apps..."
ForEach ($bloat in $bloatware) {
    Get-AppxPackage "*$Bloat*" | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$Bloat*" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    Write-Host "Trying to remove $Bloat." -ForegroundColor Yellow
}
Write-Host "Finished Removing Bloatware Apps"

Write-Host "Removing Bloatware Programs..."
$InstalledPrograms = Get-Package | Where-Object { $UninstallPrograms -contains $_.Name }
$InstalledPrograms | ForEach-Object {
    Write-Host -Object "Attempting to Uninstall: [$( $_.Name )]..." -ForegroundColor Yellow
    try {
        $Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction SilentlyContinue
        Write-Host -Object "Successfully Uninstalled: [$( $_.Name )]" -ForegroundColor Green
    }
    catch {
        Write-Warning -Message "Failed to Uninstall: [$( $_.Name )]"
    }
}
Write-Host "Finished Removing Bloatware Programs"
#>
# Remove Cortana

Write-Host "Removing Cortana..."
Get-AppxPackage -AllUsers Microsoft.549981C3F5F10 | Remove-AppxPackage


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
if (!(Get-InstalledModule -Name "7Zip4Powershell" -ErrorAction SilentlyContinue)) {
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


## Delete Temporary Files
#Write-Host "Delete Temp Files"
#Get-ChildItem -Path "C:\Windows\Temp" *.* -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
#Get-ChildItem -Path $env:TEMP *.* -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

## Run Disk Cleanup
#Write-Host "Running Disk Cleanup on Drive C:..."
#cmd /c cleanmgr.exe /d C: /VERYLOWDISK
