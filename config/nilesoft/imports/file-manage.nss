menu(
	where = sel.count > 0
	mode  = multiple
	type  = 'file|dir|drive|namespace|back'
	title = 'File Manage'
	icon  = \uE253
)
{
	item(
		title = title.copy_path
		icon  = icon.copy_path
		cmd   = command.copy(sel.path)
	)

	separator

	item(
		type  = 'file|dir|back.dir|drive'
		title = 'Take Ownership'
		icon  = [\uE194, #f00]
		cmd   = 'wt.exe'
		args  = 'cmd.exe /c takeown /f "@sel.path" @if(sel.type==1,null,"/r /d y") && icacls "@sel.path" /grant *S-1-5-32-544:F @if(sel.type==1,"/c /l","/t /c /l /q")'
		admin
	)

	separator

	menu(
		mode     = single
		type     = 'back'
		expanded = true
	)
	{
		menu(
			title = 'New Folder'
			icon  = icon.new_folder
		)
		{
			item(
				title = 'DateTime'
				cmd   = io.dir.create(sys.datetime('ymdHMSs'))
			)

			item(
				title = 'Guid'
				cmd   = io.dir.create(str.guid)
			)
		}

		menu(
			title = 'New File'
			icon  = icon.new_file
		)
		{
			item(
				title = 'TXT'
				cmd   = io.file.create('file.txt', 'Hello World!')
			)

			item(
				title = 'XML'
				cmd   = io.file.create('file.xml', '<root>Hello World!</root>')
			)

			item(
				title = 'JSON'
				cmd   = io.file.create('file.json', '[]')
			)

			item(
				title = 'HTML'
				cmd   = io.file.create('file.html', "<html>\n\t<head>\n\t</head>\n\t<body>\n\t\tHello World!\n\t</body>\n</html>")
			)
		}
	}
}
