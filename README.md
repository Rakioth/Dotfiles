<h1 align="center">
  <🌀> Dotfiles
</h1>

<p align="center">
  Opinionated dotfiles structure for effortless organization and configuration management.
  <br />
  <sub>Powered by <a href="https://github.com/anishathalye/dotbot">Dotbot</a> ⚡ — seamless cross‑platform symlink handling</sub>
</p>

## 🚀 Installation

PowerShell

```bash
iex (irm link.raks.dev/pwsh)
```

Bash

```bash
bash <(curl -fsSL link.raks.dev/bash)
```

## 🌴 Folder Structure

```bash
├── 📁 bin        # Binaries available to shells via aliases (dot command)
├── 📁 config     # App configs (bat, lsd, starship, …)
├── 📁 core       # Reusable functions importable by any script
├── 📁 doc        # Documentation for your dotfiles
├── 📁 docker     # Helper scripts for Docker workflows
├── 📁 editors    # Editor configs (VS Code, IntelliJ, Neovim, …)
├── 📁 modules    # Git submodules (e.g., Dotbot)
├── 📁 os         # OS‑specific app installers
├── 📁 package    # Package manager scripts (clean, search, update, …)
├── 📁 scripts    # General‑purpose custom scripts
├── 📁 shell      # Shell configs (Bash, Zsh, Pwsh, …)
└── 📁 symlinks   # Symlink definitions & management
```
