<h1 align="center">
  <📦> Installation Guide
</h1>

<p align="center">
  A minimal, clean, and direct checklist for setting up a new Windows computer with your dotfiles.
</p>

## 🪟 Windows Setup

- **Time & Currency Format** ➝ `English (World)`
- **Username** ➝ `raks`

## ⏳ After Installation

- 🔄 Run **Windows Update**
- 🌍 Adjust **Region & Language**:
  - _Time & Language_ ➝ _Language & Region_
    - Country/Region ➝ **Spain**
    - Regional Format ➝ **Recommended**
- ⌨️ Adjust **Keyboard Language Input**:
  - _Time & Language_ ➝ _Language & Region_ ➝ _Options_
    - Remove unwanted keyboard layouts, keeping only the desired input method:
      - `InputMethodTips : {0409:0000040A}`
  - Open **Registry Editor** and verify only the correct layouts remain in:
    - `HKCU:\Keyboard Layout\Preload`
    - `HKCU:\Keyboard Layout\Substitutes`
    - `HKU:\.DEFAULT\Keyboard Layout\Preload`
    - `HKU:\.DEFAULT\Keyboard Layout\Substitutes`
  - In _Time & Language_ ➝ _Language & Region_ ➝ **Administrative language settings**:
    - Click **Copy settings...**
    - Check **both** checkboxes and click **OK**
- 🔑 Sign in with **Microsoft Account**

## 🟣 Post-Dotfiles Setup

- 🔁 Restart computer
- 🛍️ Update **Microsoft Store** apps
- 🧹 Remove **unwanted preinstalled apps**
- ⚡ Clean **Startup Programs**:
  - `Win + R` ➝ `shell:startup` & `shell:common startup`
  - **Registry Editor** ➝
    - `HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`
    - `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`
  - **Task Scheduler** ➝ Disable unnecessary tasks

## ⭐ Miscellaneous Tweaks

- 🖼️ **Background**: Solid Color → **Black**
  - _Personalization_ ➝ _Background_
- 🔒 **Lock Screen**:
  - Change picture
  - _Personalization_ ➝ _Lock Screen_
  - Lock screen status ➝ **None**
  - Enable _Show lock screen background picture on sign-in screen_
- 🗑️ **Recycle Bin**: Rename to **Bin** & disable
  - _Personalization_ ➝ _Themes_ ➝ _Desktop Icon Settings_
- 📂 **File Explorer**:
  - Unpin default folders from Quick Access
  - Pin **work folders** to Quick Access
- 📌 **Start Menu**: Unpin all default apps
