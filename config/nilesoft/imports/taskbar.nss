menu(
	where    = @(this.count == 0)
	type     = 'taskbar'
	icon     = icon.settings
	expanded = true
)
{
	item(
		title = title.settings
		icon  = inherit
		cmd   = 'ms-settings:'
	)

	separator

	item(
		title = title.task_manager
		icon  = icon.task_manager
		cmd   = 'taskmgr.exe'
	)

	separator

	item(
		title = title.exit_explorer
		icon  = \uE139
		cmd   = command.restart_explorer
	)
}
