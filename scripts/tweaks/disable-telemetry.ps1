#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

Util-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"     -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater"                    -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy"                                                -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"         -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"              -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient"                                       -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"                     -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting"                       -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\MareBackup"                            -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\StartupAppTask"                        -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\PcaPatchDbTask"                        -Disabled
Util-ScheduledTask -TaskName "Microsoft\Windows\Maps\MapsUpdateTask"                                          -Disabled

Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"         -Name "AllowTelemetry"                               -Value "0"          -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"                        -Name "AllowTelemetry"                               -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"          -Name "ContentDeliveryAllowed"                       -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"          -Name "OemPreInstalledAppsEnabled"                   -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"          -Name "PreInstalledAppsEnabled"                      -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"          -Name "PreInstalledAppsEverEnabled"                  -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"          -Name "SilentInstalledAppsEnabled"                   -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"          -Name "SubscribedContent-338387Enabled"              -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"          -Name "SubscribedContent-338388Enabled"              -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"          -Name "SubscribedContent-338389Enabled"              -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"          -Name "SubscribedContent-353698Enabled"              -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"          -Name "SystemPaneSuggestionsEnabled"                 -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"                                             -Name "NumberOfSIUFInPeriod"                         -Value "0"          -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"                        -Name "DoNotShowFeedbackNotifications"               -Value "1"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"                          -Name "DisableTailoredExperiencesWithDiagnosticData" -Value "1"          -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"                       -Name "DisabledByGroupPolicy"                        -Value "1"          -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"                        -Name "Disabled"                                     -Value "1"          -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"     -Name "DODownloadMode"                               -Value "1"          -Type DWord
Util-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance"                        -Name "fAllowToGetHelp"                              -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode"                               -Value "1"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"               -Name "ShowTaskViewButton"                           -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"        -Name "PeopleBand"                                   -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"               -Name "LaunchTo"                                     -Value "1"          -Type DWord
Util-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"                               -Name "LongPathsEnabled"                             -Value "1"          -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"                 -Name "SearchOrderConfig"                            -Value "1"          -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"     -Name "SystemResponsiveness"                         -Value "0"          -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"     -Name "NetworkThrottlingIndex"                       -Value "4294967295" -Type DWord
Util-ItemProperty -Path "HKCU:\Control Panel\Desktop"                                                     -Name "MenuShowDelay"                                -Value "1"          -Type DWord
Util-ItemProperty -Path "HKCU:\Control Panel\Desktop"                                                     -Name "AutoEndTasks"                                 -Value "1"          -Type DWord
Util-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"        -Name "ClearPageFileAtShutdown"                      -Value "0"          -Type DWord
Util-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Services\Ndu"                                         -Name "Start"                                        -Value "2"          -Type DWord
Util-ItemProperty -Path "HKCU:\Control Panel\Mouse"                                                       -Name "MouseHoverTime"                               -Value "400"        -Type String
Util-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"                 -Name "IRPStackSize"                                 -Value "30"         -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"                         -Name "EnableFeeds"                                  -Value "0"          -Type DWord
Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"                           -Name "ShellFeedsTaskbarViewMode"                    -Value "2"          -Type DWord
Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"               -Name "HideSCAMeetNow"                               -Value "1"          -Type DWord
Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement"           -Name "ScoobeSystemSettingEnabled"                   -Value "0"          -Type DWord

bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "CurrentBuild").CurrentBuild -lt 22557) {
    $taskmgr = Start-Process -FilePath "taskmgr.exe" -WindowStyle Hidden -PassThru
    do {
        Start-Sleep -Milliseconds 100
        $preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
    } until ($preferences)
    Stop-Process $taskmgr
    $preferences.Preferences[28] = 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Value $preferences.Preferences -Type Binary
}
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

if (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge") {
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Recurse -ErrorAction SilentlyContinue
}

$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Value $ram -Type DWord -Force
$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
if (Test-Path -Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
    Remove-Item -Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
}
icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction SilentlyContinue | Out-Null
