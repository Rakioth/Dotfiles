<h1 align="center">
    <🎨> Rak's Dotfiles
</h1>
<div align="center">
    <img src="https://steamuserimages-a.akamaihd.net/ugc/1818888748735729643/07049E925D66C8C3DF2A44AC7CAE25DD10419EAE/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false"/>
    <p>🐢💨 Repository containing all the automation required to setup your Windows after a fresh install</p>
</div>
<br/>

## 🚧 Pre-Install

1. Completely Update Windows System
2. Modify System Settings
3. Change Accent Color &nbsp;![](outdated/ShareX/accent.png) #891798
4. Modify Keyboard Layouts
    * **Time & Language** > **Language & Region** > **Options**
        * Remove Unwanted Keyboard Layouts
    * **Time & Language** > **Typing** > **Advanced Keyboard Settings**
        * _Click_ &nbsp;➤&nbsp; "Language Bar Options" &nbsp;|&nbsp; _Select_ &nbsp;➤&nbsp; "Hidden"
        * _Click_ &nbsp;➤&nbsp; "Input Language Hot Keys" &nbsp;|&nbsp; _Select_ &nbsp;➤&nbsp; "Change Key Sequence to (
          None)"

## 🐙 Installation

Launch PowerShell as Administrator

```
irm raw.githubusercontent.com/Rakioth/Dotfiles/main/dotfiles | iex
```

## 🧰 Post-Install

Apply Themes

* AccentColorizer &nbsp;➤&nbsp; **Color Violet Red Light** > **Apply**
* ANTP &nbsp;➤&nbsp; **Configure** > **Import/Export** > **Import Tile String**
* Aseprite &nbsp;➤&nbsp; **Edit** > **Preferences** > **Theme**
* Blender &nbsp;➤&nbsp; **File** > **User Preferences** > **Themes**
* Photoshop &nbsp;➤&nbsp; **Edit** > **Preferences** > **Interface**
* PowerToys &nbsp;➤&nbsp; **General** > **Backup & Restore** > **Restore**
* qBittorrent &nbsp;➤&nbsp; **Tools** > **Options** > **Behavior**

Clean StartUp by Removing Unwanted Programs

* `Win` + `R`
    * shell:startup
    * shell:common startup
* `Registry Editor`
    * HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
    * HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
* `Task Scheduler`
    * Disable Tasks from Library

Setup ArchWSL

```bash
[root@PC-NAME] passwd
[root@PC-NAME] echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
[root@PC-NAME] useradd -m -G wheel -s /bin/bash raks
[root@PC-NAME] passwd raks
[root@PC-NAME] exit
> Arch.exe config --default-user raks
```

```
curl https://raw.githubusercontent.com/Rakioth/Dotfiles/main/helpers/arch | sudo bash
```
