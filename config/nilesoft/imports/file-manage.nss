menu(
	where = sel.count
	type  = '~back.namespace|~namespace|~computer|~recyclebin|~taskbar'
	title = 'File Manage'
	icon  = icon.view
)
{
	item(
		type  = '~back.namespace|~namespace|~computer|~recyclebin|~taskbar'
		title = 'Take Ownership'
		sep   = bottom
		icon  = [\uE194, #f00]
		cmd   = 'wt.exe'
		args  = 'cmd.exe /c takeown /f "@sel.path" @if(sel.type == 1, null, "/r /d y") && icacls "@sel.path" /grant *S-1-5-32-544:F @if(sel.type == 1, "/c /l", "/t /c /l /q")'
		admin
	)
}

modify(
	find  = 'compressed'
	in    = 'send to'
	menu  = 'file manage'
	title = 'Compress to ZIP file'
	icon  = icon.compressed
)

modify(
	find = 'extract'
	menu = 'file manage'
)

modify(
	find = 'shortcut'
	menu = 'file manage'
	sep  = top
)

modify(
	find = 'path'
	menu = 'file manage'
)

modify(
	find = 'file location'
	menu = 'file manage'
)
