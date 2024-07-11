<h1 align="center">
  <<img src="https://github.com/Rakioth/Dotfiles/assets/75569411/fdd1f10e-f2e9-452f-af4f-b37ff5e783fb" alt="Carpeta De Archivos" width="33"/>> Dotfiles
</h1>

<img src="https://github.com/Rakioth/Dotfiles/assets/75569411/16f356ab-0324-420b-a89b-c5e4db8ba4af" alt="Logo Dotfiles" align="left" width="192"/>

## Resumen Proyecto

Organiza y personaliza sin esfuerzo tus dotfiles con esta estructura opinionada.

Simplifica tu configuración y mantén el control.

Utilizando [Dotbot](https://github.com/anishathalye/dotbot), una herramienta multiplataforma para la gestión de enlaces simbólicos sin complicaciones.

<br/>

## <img src="https://github.com/Rakioth/Dotfiles/assets/75569411/a2604e26-58d1-49d8-8445-73b34610a0a6" alt="Cohete" width="25"/> Instalación

Usando powershell

```powershell
irm link.raks.dev/pwsh | iex
```

Usando bash

```bash
curl -fsSL link.raks.dev/bash | bash
```

## <img src="https://github.com/Rakioth/Dotfiles/assets/75569411/21cd31b4-955c-44ca-a35f-32b6f74278be" alt="Palmera" width="25"/> Estructura de Carpetas

```bash
├── 📁 bin                 # Binarios externos (comando dot)
├── 📁 config              # Archivos de configuración de tus apps
├── 📁 doc                 # Documentación de tus dotfiles
├── 📁 editors             # Configuración de tus editores (vscode, IDEA, …)
├── 📁 modules             # Módulos de ayuda
├── 📁 os                  # Configuración específica de tu sistema operativo o apps
├── 📁 package             # Funciones extendidas para tu gestor de paquetes
├── 📁 resources           # Recursos gráficos (iconos, tiles, …)
├── 📁 scripts             # Tus scripts personalizados
├── 📁 shell               # Archivos de configuración Bash/Zsh/Pwsh?…
└── 📁 symlinks            # La configuración de tus enlaces simbólicos
```
