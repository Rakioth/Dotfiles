menu(
	where = sel.count
	type  = '~back.namespace|~namespace|~computer|~recyclebin|~taskbar'
	title = 'Editors'
	icon  = \uE26E
)
{
	$version = reg.get('HKLM\SOFTWARE\Classes\Applications\idea64.exe\shell\open', 'FriendlyAppName')

	item(
		title = 'Neovim'
		icon  = '%ProgramFiles%\Neovim\share\nvim\runtime\neovim.ico'
		cmd   = 'wt.exe'
		arg   = '--profile "PowerShell" nvim "@sel.path"'
	)

	item(
		title = 'IntelliJ IDEA'
		icon
		cmd   = '%ProgramFiles(x86)%\JetBrains\' + version + '\bin\idea64.exe'
		arg   = '"@sel.path"'
	)

	item(
		title = 'Visual Studio Code'
		icon
		cmd   = '%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe'
		arg   = '"@sel.path"'
	)
}
