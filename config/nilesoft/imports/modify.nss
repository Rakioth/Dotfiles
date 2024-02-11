modify(
	find = '"open"|acrobat'
	title = 'Open'
	icon = \uE181
)

modify(
	find = 'open file location'
	menu = 'file manage'
)

modify(
	find = 'file converter'
	icon = icon.convert_to
)

modify(
	find = 'show desktop icons'
	in   = 'view'
	menu = ""
	pos  = top
)

modify(
	find  = 'compressed'
	in    = 'send to'
	menu  = ""
	title = 'Compress to ZIP file'
	pos   = 2
	icon  = icon.compressed
)

modify(
	find  = 'shortcut'
	in    = 'send to'
	menu  = 'file manage'
	title = 'Create shortcut'
	icon  = icon.create_shortcut
)

modify(
	find = 'install for all users'
	icon = [\uE291, @image.color2]
)

modify(
	find = 'using this file?'
	icon = \uE19B
	pos  = bottom
)

modify(
	find = 'powerrename'
	icon = icon.rename
	pos  = bottom
)

modify(
	find = 'resize pictures'
	icon = icon.auto_arrange_icons
	pos  = bottom
)
