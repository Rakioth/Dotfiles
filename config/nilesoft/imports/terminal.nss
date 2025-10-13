remove(
	find = 'terminal'
)

menu(
	where = sel.count
	type  = '~file|~back.namespace|~namespace|~computer|~recyclebin|~taskbar'
	title = title.terminal
	sep   = top
	icon  = icon.run_with_powershell
)
{
	$has_admin     = key.shift() or key.rbutton()
	$tip_run_admin = ["\xE1A7 Shift+Click to open as administrator", tip.warning, 1.0]

	item(
		title = 'PowerShell'
		icon  = 'pwsh.exe'
		cmd   = 'wt.exe'
		args  = '--profile "PowerShell" --startingDirectory "@sel.dir"'
		admin = has_admin
		tip   = tip_run_admin
	)

	item(
		title = 'Command Prompt'
		icon  = 'cmd.exe'
		cmd   = 'wt.exe'
		args  = '--profile "Command Prompt" --startingDirectory "@sel.dir"'
		admin = has_admin
		tip   = tip_run_admin
	)

	item(
		title = 'ArchLinux'
		icon  = '%DOTFILES%\config\terminal\shortcut.ico'
		cmd   = 'wt.exe'
		args  = '--profile "ArchLinux" --startingDirectory "@sel.dir"'
		admin = has_admin
		tip   = tip_run_admin
	)
}
