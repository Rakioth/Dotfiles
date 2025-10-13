menu(
	where    = @(this.count == 0)
	type     = 'taskbar'
	icon     = icon.settings
	expanded = true
)
{
	item(
		title = title.taskbar_Settings
		icon  = inherit
		cmd   = 'ms-settings:taskbar'
	)

	item(
		title = title.exit_explorer
		icon  = [\uE139, #f00]
		cmd   = command.restart_explorer
	)
}
