<h1 align="center">
  <<img src="https://github.com/Rakioth/Dotfiles/assets/75569411/fdd1f10e-f2e9-452f-af4f-b37ff5e783fb" alt="File Folder" width="33"/>> Dotfiles
</h1>

<img src="https://github.com/Rakioth/Dotfiles/assets/75569411/16f356ab-0324-420b-a89b-c5e4db8ba4af" alt="Dotfiles Logo" align="left" width="192"/>

## Project Overview

Effortlessly organize and customize your dotfiles with this opinionated structure.

Simplify your configuration setup and stay in control.

Utilizing [Dotbot](https://github.com/anishathalye/dotbot), a cross-platform tool for seamless symlink management.

<br/>

## <img src="https://github.com/Rakioth/Dotfiles/assets/75569411/a2604e26-58d1-49d8-8445-73b34610a0a6" alt="Rocket" width="25"/> Installation

Using powershell

```powershell
irm raw.githubusercontent.com/Rakioth/Dotfiles/main/installer.ps1 | iex
```

Using bash

```bash
curl -fsSL raw.githubusercontent.com/Rakioth/Dotfiles/main/installer.sh | bash
```

## <img src="https://github.com/Rakioth/Dotfiles/assets/75569411/21cd31b4-955c-44ca-a35f-32b6f74278be" alt="Palm Tree" width="25"/> Folder Structure

```bash
├── 📁 bin                 # External binaries (dot command)
├── 📁 config              # Configuration files of your apps
├── 📁 doc                 # Documentation of your dotfiles
├── 📁 editors             # Settings of your editors (vscode, IDEA, …)
├── 📁 modules             # Helper modules
├── 📁 os                  # Specific config of your Operative System or apps
├── 📁 package             # Extended functions for your package manager
├── 📁 resources           # Graphical resources (icons, tiles, …)
├── 📁 scripts             # Your custom scripts
├── 📁 shell               # Bash/Zsh/Pwsh?… configuration files
└── 📁 symlinks            # The config of your symlinks
```
