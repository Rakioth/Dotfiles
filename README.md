# 👨‍💻 Rak's Dotfiles

<img style="display: block; margin: 0 auto; border-radius: 25px;" src="https://steamuserimages-a.akamaihd.net/ugc/1818888748735729643/07049E925D66C8C3DF2A44AC7CAE25DD10419EAE/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false" />

## 📜 Table of Contents

- [👨‍💻 VMs Configuration in VirtualBox](#vms-configuration-in-virtualbox)
    - [🤖 Build](#build)
    - [📡 Network Interface](#network-interface)
- [🌐 Network Configuration](#network-configuration)
- [💾 File Configuration](#file-configuration)
    - [💽 Hostname](#hostname)
    - [💿 Hosts](#hosts)
- [📶 Router Configuration](#router-configuration)
    - [⏳ Packet Forwarding](#packet-forwarding)
    - [🧩 Routing](#routing)
    - [🔒 Secure SSH](#secure-ssh)
- [🧰 Useful Commands](#useful-commands)

![](cover.png)

<div class="page"></div>

## 👨‍💻 VMs Configuration in VirtualBox

### 🤖 Build

- 1 CPU
- 3GB RAM
- 50GB Dynamically Allocated Hard Disk
- OS [<font color=#C698F2> _Ubuntu Server 22.04.1_</font>](https://ubuntu.com/download/server) for the **ROUTER**
- OS [<font color=#C698F2> _Ubuntu Desktop 22.04.1_</font>](https://ubuntu.com/download/desktop) for the **SERVER** and
  the **CLIENT**

### 📡 Network Interface

- **ROUTER**
    - Adapter 1 = <font color=#B8BB26>_Bridged_</font> Adapter
    - Adapter 2 = Internal Network <font color=#B8BB26>_dmz_</font>
    - Adapter 3 = Internal Network <font color=#B8BB26>_pri_</font>
- **SERVER**
    - Adapter 1 = Internal Network <font color=#B8BB26>_dmz_</font>
- **CLIENT**
    - Adapter 1 = Internal Network <font color=#B8BB26>_pri_</font>

## 🌐 Network Configuration

The _Netplan_ default configuration file is under the directory `/etc/netplan`, where there may be several `.yaml` files
that together define the network configuration plan.

> 💡 Before editing the `.yaml` file, it is recommendable to backup the file by renaming its extension to `.bak`, in
> order to be able to revert to the initial configuration in case something goes wrong.

<br>

```bash
└── 📁 etc
   └── 📁 netplan
      ├── 00-installer-config.yaml      # YAML in Ubuntu Server
      └── 01-network-manager-all.yaml   # YAML in Ubuntu Desktop
```

> ⚠️ Note that **YAML** files are rather strict in the indentation. Make use of spaces for indentation, not tabs.
> Otherwise, you will encounter an error.

Now apply the new configurations by running the following command as sudo: `sudo netplan apply`.

## 💾 File Configuration

To make modifications to system files for convenience we will switch to super user using the `sudo su` command so we
don't have to worry about whether or not we have privileges to modify x file.

### 💽 Hostname

The **hostname** file contains the machine name. We can change it using the `echo` command or through our text editor,
in the case of Ubuntu we can use `nano` which is included in the system.

To change the hostname we will modify the `/etc/hostname` file.

```bash
$ sudo su
$ echo nombre > etc/hostname  # The name must be in lowercase
$ reboot                      # Restart the computer for the changes to take effect
```

# Dotfiles

## ANTP

* **`ANTP Edit`** is a modified extension adapted for laptop screen sizes.
* **`Tile String.txt`** is file that contains a string with all of my ANTP preferences.

## Adobe Photoshop

* Place **`Required`** folder inside Adobe Photoshop installation directory.
* Select the darkest color theme available in `Edit > Preferences > Interface`.

## Aseprite

* Place **`Aseprite`** folder inside `%AppData%`.
* Theme will be available in `Edit > Preferences > Theme`.

## Blender

* Place **`Blender Foundation`** folder inside `%AppData%`.
* Theme will be available in `File > User Preferences > Themes`.

## qBittorrent

* Place **`themes`** folder inside qBittorrent installation directory.
* Theme will be available in `Tools > Options > Behavior`.
