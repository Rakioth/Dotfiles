remove(
	find = 'visual studio code'
	in   = 'open with'
)

remove(
	find = 'microsoft clipchamp'
	in   = 'open with'
)

remove(
	find = 'registry editor'
	in   = 'open with'
)

remove(
	find = 'git'
	in   = 'open with'
)

remove(
	find = '"notepad"'
	in   = 'open with'
)

modify(
	find = '010 editor'
	menu = 'open with'
	pos  = top
)

modify(
	find  = 'clipchamp'
	menu  = 'open with'
	title = 'Clipchamp'
	pos   = top
)

modify(
	find  = 'notepad'
	menu  = 'open with'
	title = 'Notepad'
	pos   = top
)

item(
	menu  = 'open with'
	title = 'Photoshop'
	pos   = top
	icon
	cmd   = 'C:\Program Files\Adobe\Adobe Photoshop 2024\Photoshop.exe'
	arg   = '"@sel.path"'
)
