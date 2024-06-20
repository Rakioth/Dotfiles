#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Run OO Shutup
Start-BitsTransfer -Source "https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/config/ooshutup10_factory.cfg" -Destination "$env:TEMP\ooshutup10.cfg"
Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"                                     -Destination "$env:TEMP\OOSU10.exe"
Start-Process -FilePath "$env:TEMP\OOSU10.exe" -ArgumentList "$env:TEMP\ooshutup10.cfg /quiet" -Wait

# Disable Telemetry
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\MareBackup"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\StartupAppTask"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\PcaPatchDbTask"
Disable-ScheduledTask -TaskName "Microsoft\Windows\Maps\MapsUpdateTask"

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"                 -Name "AllowTelemetry"                               -Value "0"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"                                -Name "AllowTelemetry"                               -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"                  -Name "ContentDeliveryAllowed"                       -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"                  -Name "OemPreInstalledAppsEnabled"                   -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"                  -Name "PreInstalledAppsEnabled"                      -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"                  -Name "PreInstalledAppsEverEnabled"                  -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"                  -Name "SilentInstalledAppsEnabled"                   -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"                  -Name "SubscribedContent-338387Enabled"              -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"                  -Name "SubscribedContent-338388Enabled"              -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"                  -Name "SubscribedContent-338389Enabled"              -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"                  -Name "SubscribedContent-353698Enabled"              -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"                  -Name "SystemPaneSuggestionsEnabled"                 -Value "0"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"                                  -Name "DisableWindowsConsumerFeatures"               -Value "1"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules"                                                     -Name "NumberOfSIUFInPeriod"                         -Value "0"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"                                -Name "DoNotShowFeedbackNotifications"               -Value "1"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent"                                  -Name "DisableTailoredExperiencesWithDiagnosticData" -Value "1"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"                               -Name "DisabledByGroupPolicy"                        -Value "1"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"                                -Name "Disabled"                                     -Value "1"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"             -Name "DODownloadMode"                               -Value "1"          -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance"                                -Name "fAllowToGetHelp"                              -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager"         -Name "EnthusiastMode"                               -Value "1"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                       -Name "ShowTaskViewButton"                           -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"                -Name "PeopleBand"                                   -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                       -Name "LaunchTo"                                     -Value "1"          -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"                                       -Name "LongPathsEnabled"                             -Value "1"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"                         -Name "SearchOrderConfig"                            -Value "1"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"             -Name "SystemResponsiveness"                         -Value "0"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"             -Name "NetworkThrottlingIndex"                       -Value "4294967295" -Type DWord
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop"                                                             -Name "MenuShowDelay"                                -Value "1"          -Type DWord
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop"                                                             -Name "AutoEndTasks"                                 -Value "1"          -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"                -Name "ClearPageFileAtShutdown"                      -Value "0"          -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Services\Ndu"                                                 -Name "Start"                                        -Value "2"          -Type DWord
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse"                                                               -Name "MouseHoverTime"                               -Value "400"        -Type String
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"                         -Name "IRPStackSize"                                 -Value "30"         -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Windows Feeds"                                 -Name "EnableFeeds"                                  -Value "0"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"                                   -Name "ShellFeedsTaskbarViewMode"                    -Value "2"          -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"                       -Name "HideSCAMeetNow"                               -Value "1"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority"                                 -Value "8"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority"                                     -Value "6"          -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category"                          -Value "High"       -Type String

bcdedit /set `{current`} bootmenupolicy Legacy
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -Force
Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Recurse -Force
$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Value $ram -Type DWord -Force
$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
Remove-Item -Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl" -Force
icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F
Set-MpPreference -SubmitSamplesConsent 2

# Disable Wifi-Sense
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"           -Name "Value" -Value "0" -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Value "0" -Type DWord

# Disable Location Tracking
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"              -Name "Value"                 -Value "Deny" -Type String
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Value "0"    -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"                                        -Name "Status"                -Value "0"    -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\Maps"                                                                                          -Name "AutoUpdateEnabled"     -Value "0"    -Type DWord

# Disable GameDVR
Set-ItemProperty -Path "HKCU:\System\GameConfigStore"                      -Name "GameDVR_FSEBehavior"                   -Value "2" -Type DWord
Set-ItemProperty -Path "HKCU:\System\GameConfigStore"                      -Name "GameDVR_Enabled"                       -Value "0" -Type DWord
Set-ItemProperty -Path "HKCU:\System\GameConfigStore"                      -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Value "1" -Type DWord
Set-ItemProperty -Path "HKCU:\System\GameConfigStore"                      -Name "GameDVR_HonorUserFSEBehaviorMode"      -Value "1" -Type DWord
Set-ItemProperty -Path "HKCU:\System\GameConfigStore"                      -Name "GameDVR_EFSEFeatureFlags"              -Value "0" -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR"                          -Value "0" -Type DWord

# Set Services to Manual
Get-Service -Name "AJRouter"                                 | Set-Service -StartupType Disabled
Get-Service -Name "ALG"                                      | Set-Service -StartupType Manual
Get-Service -Name "AppIDSvc"                                 | Set-Service -StartupType Manual
Get-Service -Name "AppMgmt"                                  | Set-Service -StartupType Manual
Get-Service -Name "AppReadiness"                             | Set-Service -StartupType Manual
Get-Service -Name "AppVClient"                               | Set-Service -StartupType Disabled
Get-Service -Name "AppXSvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "Appinfo"                                  | Set-Service -StartupType Manual
Get-Service -Name "AssignedAccessManagerSvc"                 | Set-Service -StartupType Disabled
Get-Service -Name "AudioEndpointBuilder"                     | Set-Service -StartupType Automatic
Get-Service -Name "AudioSrv"                                 | Set-Service -StartupType Automatic
Get-Service -Name "Audiosrv"                                 | Set-Service -StartupType Automatic
Get-Service -Name "AxInstSV"                                 | Set-Service -StartupType Manual
Get-Service -Name "BDESVC"                                   | Set-Service -StartupType Manual
Get-Service -Name "BFE"                                      | Set-Service -StartupType Automatic
Get-Service -Name "BITS"                                     | Set-Service -StartupType AutomaticDelayedStart
Get-Service -Name "BTAGService"                              | Set-Service -StartupType Manual
Get-Service -Name "BcastDVRUserService_*"                    | Set-Service -StartupType Manual
Get-Service -Name "BluetoothUserService_*"                   | Set-Service -StartupType Manual
Get-Service -Name "BrokerInfrastructure"                     | Set-Service -StartupType Automatic
Get-Service -Name "Browser"                                  | Set-Service -StartupType Manual
Get-Service -Name "BthAvctpSvc"                              | Set-Service -StartupType Automatic
Get-Service -Name "BthHFSrv"                                 | Set-Service -StartupType Automatic
Get-Service -Name "CDPSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "CDPUserSvc_*"                             | Set-Service -StartupType Automatic
Get-Service -Name "COMSysApp"                                | Set-Service -StartupType Manual
Get-Service -Name "CaptureService_*"                         | Set-Service -StartupType Manual
Get-Service -Name "CertPropSvc"                              | Set-Service -StartupType Manual
Get-Service -Name "ClipSVC"                                  | Set-Service -StartupType Manual
Get-Service -Name "ConsentUxUserSvc_*"                       | Set-Service -StartupType Manual
Get-Service -Name "CoreMessagingRegistrar"                   | Set-Service -StartupType Automatic
Get-Service -Name "CredentialEnrollmentManagerUserSvc_*"     | Set-Service -StartupType Manual
Get-Service -Name "CryptSvc"                                 | Set-Service -StartupType Automatic
Get-Service -Name "CscService"                               | Set-Service -StartupType Manual
Get-Service -Name "DPS"                                      | Set-Service -StartupType Automatic
Get-Service -Name "DcomLaunch"                               | Set-Service -StartupType Automatic
Get-Service -Name "DcpSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "DevQueryBroker"                           | Set-Service -StartupType Manual
Get-Service -Name "DeviceAssociationBrokerSvc_*"             | Set-Service -StartupType Manual
Get-Service -Name "DeviceAssociationService"                 | Set-Service -StartupType Manual
Get-Service -Name "DeviceInstall"                            | Set-Service -StartupType Manual
Get-Service -Name "DevicePickerUserSvc_*"                    | Set-Service -StartupType Manual
Get-Service -Name "DevicesFlowUserSvc_*"                     | Set-Service -StartupType Manual
Get-Service -Name "Dhcp"                                     | Set-Service -StartupType Automatic
Get-Service -Name "DiagTrack"                                | Set-Service -StartupType Disabled
Get-Service -Name "DialogBlockingService"                    | Set-Service -StartupType Disabled
Get-Service -Name "DispBrokerDesktopSvc"                     | Set-Service -StartupType Automatic
Get-Service -Name "DisplayEnhancementService"                | Set-Service -StartupType Manual
Get-Service -Name "DmEnrollmentSvc"                          | Set-Service -StartupType Manual
Get-Service -Name "Dnscache"                                 | Set-Service -StartupType Automatic
Get-Service -Name "DoSvc"                                    | Set-Service -StartupType AutomaticDelayedStart
Get-Service -Name "DsSvc"                                    | Set-Service -StartupType Manual
Get-Service -Name "DsmSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "DusmSvc"                                  | Set-Service -StartupType Automatic
Get-Service -Name "EFS"                                      | Set-Service -StartupType Manual
Get-Service -Name "EapHost"                                  | Set-Service -StartupType Manual
Get-Service -Name "EntAppSvc"                                | Set-Service -StartupType Manual
Get-Service -Name "EventLog"                                 | Set-Service -StartupType Automatic
Get-Service -Name "EventSystem"                              | Set-Service -StartupType Automatic
Get-Service -Name "FDResPub"                                 | Set-Service -StartupType Manual
Get-Service -Name "Fax"                                      | Set-Service -StartupType Manual
Get-Service -Name "FontCache"                                | Set-Service -StartupType Automatic
Get-Service -Name "FrameServer"                              | Set-Service -StartupType Manual
Get-Service -Name "FrameServerMonitor"                       | Set-Service -StartupType Manual
Get-Service -Name "GraphicsPerfSvc"                          | Set-Service -StartupType Manual
Get-Service -Name "HomeGroupListener"                        | Set-Service -StartupType Manual
Get-Service -Name "HomeGroupProvider"                        | Set-Service -StartupType Manual
Get-Service -Name "HvHost"                                   | Set-Service -StartupType Manual
Get-Service -Name "IEEtwCollectorService"                    | Set-Service -StartupType Manual
Get-Service -Name "IKEEXT"                                   | Set-Service -StartupType Manual
Get-Service -Name "InstallService"                           | Set-Service -StartupType Manual
Get-Service -Name "InventorySvc"                             | Set-Service -StartupType Manual
Get-Service -Name "IpxlatCfgSvc"                             | Set-Service -StartupType Manual
Get-Service -Name "KeyIso"                                   | Set-Service -StartupType Automatic
Get-Service -Name "KtmRm"                                    | Set-Service -StartupType Manual
Get-Service -Name "LSM"                                      | Set-Service -StartupType Automatic
Get-Service -Name "LanmanServer"                             | Set-Service -StartupType Automatic
Get-Service -Name "LanmanWorkstation"                        | Set-Service -StartupType Automatic
Get-Service -Name "LicenseManager"                           | Set-Service -StartupType Manual
Get-Service -Name "LxpSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "MSDTC"                                    | Set-Service -StartupType Manual
Get-Service -Name "MSiSCSI"                                  | Set-Service -StartupType Manual
Get-Service -Name "MapsBroker"                               | Set-Service -StartupType AutomaticDelayedStart
Get-Service -Name "McpManagementService"                     | Set-Service -StartupType Manual
Get-Service -Name "MessagingService_*"                       | Set-Service -StartupType Manual
Get-Service -Name "MicrosoftEdgeElevationService"            | Set-Service -StartupType Manual
Get-Service -Name "MixedRealityOpenXRSvc"                    | Set-Service -StartupType Manual
Get-Service -Name "MpsSvc"                                   | Set-Service -StartupType Automatic
Get-Service -Name "MsKeyboardFilter"                         | Set-Service -StartupType Manual
Get-Service -Name "NPSMSvc_*"                                | Set-Service -StartupType Manual
Get-Service -Name "NaturalAuthentication"                    | Set-Service -StartupType Manual
Get-Service -Name "NcaSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "NcbService"                               | Set-Service -StartupType Manual
Get-Service -Name "NcdAutoSetup"                             | Set-Service -StartupType Manual
Get-Service -Name "NetSetupSvc"                              | Set-Service -StartupType Manual
Get-Service -Name "NetTcpPortSharing"                        | Set-Service -StartupType Disabled
Get-Service -Name "Netlogon"                                 | Set-Service -StartupType Automatic
Get-Service -Name "Netman"                                   | Set-Service -StartupType Manual
Get-Service -Name "NgcCtnrSvc"                               | Set-Service -StartupType Manual
Get-Service -Name "NgcSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "NlaSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "OneSyncSvc_*"                             | Set-Service -StartupType Automatic
Get-Service -Name "P9RdrService_*"                           | Set-Service -StartupType Manual
Get-Service -Name "PNRPAutoReg"                              | Set-Service -StartupType Manual
Get-Service -Name "PNRPsvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "PcaSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "PeerDistSvc"                              | Set-Service -StartupType Manual
Get-Service -Name "PenService_*"                             | Set-Service -StartupType Manual
Get-Service -Name "PerfHost"                                 | Set-Service -StartupType Manual
Get-Service -Name "PhoneSvc"                                 | Set-Service -StartupType Manual
Get-Service -Name "PimIndexMaintenanceSvc_*"                 | Set-Service -StartupType Manual
Get-Service -Name "PlugPlay"                                 | Set-Service -StartupType Manual
Get-Service -Name "PolicyAgent"                              | Set-Service -StartupType Manual
Get-Service -Name "Power"                                    | Set-Service -StartupType Automatic
Get-Service -Name "PrintNotify"                              | Set-Service -StartupType Manual
Get-Service -Name "PrintWorkflowUserSvc_*"                   | Set-Service -StartupType Manual
Get-Service -Name "ProfSvc"                                  | Set-Service -StartupType Automatic
Get-Service -Name "PushToInstall"                            | Set-Service -StartupType Manual
Get-Service -Name "QWAVE"                                    | Set-Service -StartupType Manual
Get-Service -Name "RasAuto"                                  | Set-Service -StartupType Manual
Get-Service -Name "RasMan"                                   | Set-Service -StartupType Manual
Get-Service -Name "RemoteAccess"                             | Set-Service -StartupType Disabled
Get-Service -Name "RemoteRegistry"                           | Set-Service -StartupType Disabled
Get-Service -Name "RetailDemo"                               | Set-Service -StartupType Manual
Get-Service -Name "RmSvc"                                    | Set-Service -StartupType Manual
Get-Service -Name "RpcEptMapper"                             | Set-Service -StartupType Automatic
Get-Service -Name "RpcLocator"                               | Set-Service -StartupType Manual
Get-Service -Name "RpcSs"                                    | Set-Service -StartupType Automatic
Get-Service -Name "SCPolicySvc"                              | Set-Service -StartupType Manual
Get-Service -Name "SCardSvr"                                 | Set-Service -StartupType Manual
Get-Service -Name "SDRSVC"                                   | Set-Service -StartupType Manual
Get-Service -Name "SEMgrSvc"                                 | Set-Service -StartupType Manual
Get-Service -Name "SENS"                                     | Set-Service -StartupType Automatic
Get-Service -Name "SNMPTRAP"                                 | Set-Service -StartupType Manual
Get-Service -Name "SNMPTrap"                                 | Set-Service -StartupType Manual
Get-Service -Name "SSDPSRV"                                  | Set-Service -StartupType Manual
Get-Service -Name "SamSs"                                    | Set-Service -StartupType Automatic
Get-Service -Name "ScDeviceEnum"                             | Set-Service -StartupType Manual
Get-Service -Name "Schedule"                                 | Set-Service -StartupType Automatic
Get-Service -Name "SecurityHealthService"                    | Set-Service -StartupType Manual
Get-Service -Name "Sense"                                    | Set-Service -StartupType Manual
Get-Service -Name "SensorDataService"                        | Set-Service -StartupType Manual
Get-Service -Name "SensorService"                            | Set-Service -StartupType Manual
Get-Service -Name "SensrSvc"                                 | Set-Service -StartupType Manual
Get-Service -Name "SessionEnv"                               | Set-Service -StartupType Manual
Get-Service -Name "SgrmBroker"                               | Set-Service -StartupType Automatic
Get-Service -Name "SharedAccess"                             | Set-Service -StartupType Manual
Get-Service -Name "SharedRealitySvc"                         | Set-Service -StartupType Manual
Get-Service -Name "ShellHWDetection"                         | Set-Service -StartupType Automatic
Get-Service -Name "SmsRouter"                                | Set-Service -StartupType Manual
Get-Service -Name "Spooler"                                  | Set-Service -StartupType Automatic
Get-Service -Name "SstpSvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "StateRepository"                          | Set-Service -StartupType Manual
Get-Service -Name "StiSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "StorSvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "SysMain"                                  | Set-Service -StartupType Automatic
Get-Service -Name "SystemEventsBroker"                       | Set-Service -StartupType Automatic
Get-Service -Name "TabletInputService"                       | Set-Service -StartupType Manual
Get-Service -Name "TapiSrv"                                  | Set-Service -StartupType Manual
Get-Service -Name "TermService"                              | Set-Service -StartupType Automatic
Get-Service -Name "TextInputManagementService"               | Set-Service -StartupType Manual
Get-Service -Name "Themes"                                   | Set-Service -StartupType Automatic
Get-Service -Name "TieringEngineService"                     | Set-Service -StartupType Manual
Get-Service -Name "TimeBroker"                               | Set-Service -StartupType Manual
Get-Service -Name "TimeBrokerSvc"                            | Set-Service -StartupType Manual
Get-Service -Name "TokenBroker"                              | Set-Service -StartupType Manual
Get-Service -Name "TrkWks"                                   | Set-Service -StartupType Automatic
Get-Service -Name "TroubleshootingSvc"                       | Set-Service -StartupType Manual
Get-Service -Name "TrustedInstaller"                         | Set-Service -StartupType Manual
Get-Service -Name "UI0Detect"                                | Set-Service -StartupType Manual
Get-Service -Name "UdkUserSvc_*"                             | Set-Service -StartupType Manual
Get-Service -Name "UevAgentService"                          | Set-Service -StartupType Disabled
Get-Service -Name "UmRdpService"                             | Set-Service -StartupType Manual
Get-Service -Name "UnistoreSvc_*"                            | Set-Service -StartupType Manual
Get-Service -Name "UserDataSvc_*"                            | Set-Service -StartupType Manual
Get-Service -Name "UserManager"                              | Set-Service -StartupType Automatic
Get-Service -Name "UsoSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "VGAuthService"                            | Set-Service -StartupType Automatic
Get-Service -Name "VMTools"                                  | Set-Service -StartupType Automatic
Get-Service -Name "VSS"                                      | Set-Service -StartupType Manual
Get-Service -Name "VacSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "VaultSvc"                                 | Set-Service -StartupType Automatic
Get-Service -Name "W32Time"                                  | Set-Service -StartupType Manual
Get-Service -Name "WEPHOSTSVC"                               | Set-Service -StartupType Manual
Get-Service -Name "WFDSConMgrSvc"                            | Set-Service -StartupType Manual
Get-Service -Name "WMPNetworkSvc"                            | Set-Service -StartupType Manual
Get-Service -Name "WManSvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "WPDBusEnum"                               | Set-Service -StartupType Manual
Get-Service -Name "WSService"                                | Set-Service -StartupType Manual
Get-Service -Name "WSearch"                                  | Set-Service -StartupType AutomaticDelayedStart
Get-Service -Name "WaaSMedicSvc"                             | Set-Service -StartupType Manual
Get-Service -Name "WalletService"                            | Set-Service -StartupType Manual
Get-Service -Name "WarpJITSvc"                               | Set-Service -StartupType Manual
Get-Service -Name "WbioSrvc"                                 | Set-Service -StartupType Manual
Get-Service -Name "Wcmsvc"                                   | Set-Service -StartupType Automatic
Get-Service -Name "WcsPlugInService"                         | Set-Service -StartupType Manual
Get-Service -Name "WdNisSvc"                                 | Set-Service -StartupType Manual
Get-Service -Name "WdiServiceHost"                           | Set-Service -StartupType Manual
Get-Service -Name "WdiSystemHost"                            | Set-Service -StartupType Manual
Get-Service -Name "WebClient"                                | Set-Service -StartupType Manual
Get-Service -Name "Wecsvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "WerSvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "WiaRpc"                                   | Set-Service -StartupType Manual
Get-Service -Name "WinDefend"                                | Set-Service -StartupType Automatic
Get-Service -Name "WinHttpAutoProxySvc"                      | Set-Service -StartupType Manual
Get-Service -Name "WinRM"                                    | Set-Service -StartupType Manual
Get-Service -Name "Winmgmt"                                  | Set-Service -StartupType Automatic
Get-Service -Name "WlanSvc"                                  | Set-Service -StartupType Automatic
Get-Service -Name "WpcMonSvc"                                | Set-Service -StartupType Manual
Get-Service -Name "WpnService"                               | Set-Service -StartupType Manual
Get-Service -Name "WpnUserService_*"                         | Set-Service -StartupType Automatic
Get-Service -Name "WwanSvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "XblAuthManager"                           | Set-Service -StartupType Manual
Get-Service -Name "XblGameSave"                              | Set-Service -StartupType Manual
Get-Service -Name "XboxGipSvc"                               | Set-Service -StartupType Manual
Get-Service -Name "XboxNetApiSvc"                            | Set-Service -StartupType Manual
Get-Service -Name "autotimesvc"                              | Set-Service -StartupType Manual
Get-Service -Name "bthserv"                                  | Set-Service -StartupType Manual
Get-Service -Name "camsvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "cbdhsvc_*"                                | Set-Service -StartupType Manual
Get-Service -Name "cloudidsvc"                               | Set-Service -StartupType Manual
Get-Service -Name "dcsvc"                                    | Set-Service -StartupType Manual
Get-Service -Name "defragsvc"                                | Set-Service -StartupType Manual
Get-Service -Name "diagnosticshub.standardcollector.service" | Set-Service -StartupType Manual
Get-Service -Name "diagsvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "dmwappushservice"                         | Set-Service -StartupType Manual
Get-Service -Name "dot3svc"                                  | Set-Service -StartupType Manual
Get-Service -Name "edgeupdate"                               | Set-Service -StartupType Manual
Get-Service -Name "edgeupdatem"                              | Set-Service -StartupType Manual
Get-Service -Name "embeddedmode"                             | Set-Service -StartupType Manual
Get-Service -Name "fdPHost"                                  | Set-Service -StartupType Manual
Get-Service -Name "fhsvc"                                    | Set-Service -StartupType Manual
Get-Service -Name "gpsvc"                                    | Set-Service -StartupType Automatic
Get-Service -Name "hidserv"                                  | Set-Service -StartupType Manual
Get-Service -Name "icssvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "iphlpsvc"                                 | Set-Service -StartupType Automatic
Get-Service -Name "lfsvc"                                    | Set-Service -StartupType Manual
Get-Service -Name "lltdsvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "lmhosts"                                  | Set-Service -StartupType Manual
Get-Service -Name "mpssvc"                                   | Set-Service -StartupType Automatic
Get-Service -Name "msiserver"                                | Set-Service -StartupType Manual
Get-Service -Name "netprofm"                                 | Set-Service -StartupType Manual
Get-Service -Name "nsi"                                      | Set-Service -StartupType Automatic
Get-Service -Name "p2pimsvc"                                 | Set-Service -StartupType Manual
Get-Service -Name "p2psvc"                                   | Set-Service -StartupType Manual
Get-Service -Name "perceptionsimulation"                     | Set-Service -StartupType Manual
Get-Service -Name "pla"                                      | Set-Service -StartupType Manual
Get-Service -Name "seclogon"                                 | Set-Service -StartupType Manual
Get-Service -Name "shpamsvc"                                 | Set-Service -StartupType Disabled
Get-Service -Name "smphost"                                  | Set-Service -StartupType Manual
Get-Service -Name "spectrum"                                 | Set-Service -StartupType Manual
Get-Service -Name "sppsvc"                                   | Set-Service -StartupType AutomaticDelayedStart
Get-Service -Name "ssh-agent"                                | Set-Service -StartupType Disabled
Get-Service -Name "svsvc"                                    | Set-Service -StartupType Manual
Get-Service -Name "swprv"                                    | Set-Service -StartupType Manual
Get-Service -Name "tiledatamodelsvc"                         | Set-Service -StartupType Automatic
Get-Service -Name "tzautoupdate"                             | Set-Service -StartupType Disabled
Get-Service -Name "uhssvc"                                   | Set-Service -StartupType Disabled
Get-Service -Name "upnphost"                                 | Set-Service -StartupType Manual
Get-Service -Name "vds"                                      | Set-Service -StartupType Manual
Get-Service -Name "vm3dservice"                              | Set-Service -StartupType Manual
Get-Service -Name "vmicguestinterface"                       | Set-Service -StartupType Manual
Get-Service -Name "vmicheartbeat"                            | Set-Service -StartupType Manual
Get-Service -Name "vmickvpexchange"                          | Set-Service -StartupType Manual
Get-Service -Name "vmicrdv"                                  | Set-Service -StartupType Manual
Get-Service -Name "vmicshutdown"                             | Set-Service -StartupType Manual
Get-Service -Name "vmictimesync"                             | Set-Service -StartupType Manual
Get-Service -Name "vmicvmsession"                            | Set-Service -StartupType Manual
Get-Service -Name "vmicvss"                                  | Set-Service -StartupType Manual
Get-Service -Name "vmvss"                                    | Set-Service -StartupType Manual
Get-Service -Name "wbengine"                                 | Set-Service -StartupType Manual
Get-Service -Name "wcncsvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "webthreatdefsvc"                          | Set-Service -StartupType Manual
Get-Service -Name "webthreatdefusersvc_*"                    | Set-Service -StartupType Automatic
Get-Service -Name "wercplsupport"                            | Set-Service -StartupType Manual
Get-Service -Name "wisvc"                                    | Set-Service -StartupType Manual
Get-Service -Name "wlidsvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "wlpasvc"                                  | Set-Service -StartupType Manual
Get-Service -Name "wmiApSrv"                                 | Set-Service -StartupType Manual
Get-Service -Name "workfolderssvc"                           | Set-Service -StartupType Manual
Get-Service -Name "wscsvc"                                   | Set-Service -StartupType AutomaticDelayedStart
Get-Service -Name "wuauserv"                                 | Set-Service -StartupType Manual
Get-Service -Name "wudfsvc"                                  | Set-Service -StartupType Manual

# Miscellaneous Tweaks
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"  -Name "ShowTaskViewButton"   -Value "0" -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"  -Name "TaskbarDa"            -Value "0" -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"  -Name "TaskbarMn"            -Value "0" -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"             -Name "SearchboxTaskbarMode" -Value "0" -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"             -Name "BingSearchEnabled"    -Value "0" -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme"    -Value "0" -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value "0" -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications"  -Name "ToastEnabled"         -Value "0" -Type DWord

Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name "Background" -Value "0 0 0" -Type String

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "HubMode" -Value "1" -PropertyType DWord
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" -Recurse
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" -Recurse

Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" -Name "HideIfEnabled"
Set-ItemProperty    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" -Name "HiddenByDefault" -Value "0" -Type DWord
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" -Name "HideIfEnabled"
Set-ItemProperty    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" -Name "HiddenByDefault" -Value "0" -Type DWord
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -Name "HideIfEnabled"
Set-ItemProperty    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -Name "HiddenByDefault" -Value "0" -Type DWord
Set-ItemProperty    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -Name "HiddenByDefault" -Value "0" -Type DWord
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -Name "HideIfEnabled"
Set-ItemProperty    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -Name "HiddenByDefault" -Value "0" -Type DWord

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo"                  -Value "1" -Type DWord
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard"                                      -Name "InitialKeyboardIndicators" -Value "2" -Type DWord

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value "0" -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden"      -Value "1" -Type DWord

# Security Updates
if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Force
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Value "1" -Type DWord

if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Force
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontPromptForWindowsUpdate"        -Value "1" -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontSearchWindowsUpdate"           -Value "1" -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DriverUpdateWizardWuSearchEnabled" -Value "0" -Type DWord

if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Value "1" -Type DWord

if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Value "1" -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement"             -Value "0" -Type DWord

if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Force
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "BranchReadinessLevel"            -Value "20"  -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "DeferFeatureUpdatesPeriodInDays" -Value "365" -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "DeferQualityUpdatesPeriodInDays" -Value "4"   -Type DWord

# Accent Colorizer
$downloadUri = ((Invoke-RestMethod -Method GET -Uri "https://api.github.com/repos/krlvm/AccentColorizer-E11/releases/latest").assets | Where-Object { $_.name -like "*.exe" }).browser_download_url
$fileName    = Split-Path -Path $downloadUri -Leaf
$tempPath    = Join-Path -Path $env:TEMP -ChildPath $fileName
Start-BitsTransfer -Source $downloadUri -Destination $tempPath
Start-Process -FilePath $tempPath -ArgumentList "-Apply" -Wait
Remove-Item $tempPath -Force

# Desktop CleanUp
Get-ChildItem -Path "$env:USERPROFILE\Desktop" -Filter "*.lnk" -Recurse | Remove-Item -Force
Get-ChildItem -Path "$env:PUBLIC\Desktop"      -Filter "*.lnk" -Recurse | Remove-Item -Force
