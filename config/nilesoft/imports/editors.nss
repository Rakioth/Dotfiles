menu(
	where = (sel.count or wnd.is_edit)
	type  = '*'
	title = 'Editors'
	icon  = \uE26E
)
{
	item(
		title = 'Neovim'
		icon  = 'C:\Program Files\Neovim\share\nvim\runtime\neovim.ico'
		cmd   = 'wt.exe'
		arg   = '-p PowerShell nvim "@sel.path"'
	)

	item(
		title = 'IntelliJ IDEA'
		icon
		cmd   = 'C:\Program Files (x86)\JetBrains\IntelliJ IDEA 2024.1.3\bin\idea64.exe'
		arg   = '"@sel.path"'
	)

	item(
		title = 'Visual Studio Code'
		icon
		cmd   = 'C:\Users\raks\AppData\Local\Programs\Microsoft VS Code\Code.exe'
		arg   = '"@sel.path"'
	)
}
