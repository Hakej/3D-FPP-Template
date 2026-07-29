@tool
extends EditorPlugin

const CONSOLE_NAME = "PC"

func _enable_plugin():
	add_autoload_singleton(CONSOLE_NAME, "res://addons/pathetic_console/PatheticConsole.tscn")

func _disable_plugin():
	remove_autoload_singleton(CONSOLE_NAME)
