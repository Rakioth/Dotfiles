item(
	where = (sel.count or wnd.is_edit)
	type  = '*'
	title = title.terminal
	sep   = top
	icon  = icon.run_with_powershell
	cmd   = 'wt.exe'
	arg   = '-d "@sel.path\."'
	admin = (key.shift() or key.rbutton())
)
