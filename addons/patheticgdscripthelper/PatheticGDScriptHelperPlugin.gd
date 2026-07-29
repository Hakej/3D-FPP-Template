@tool
extends EditorPlugin

var autoload_name = "GH"
var autoload_path = "res://addons/patheticgdscripthelper/PatheticGDScriptHelper.gd"

func _enter_tree():
	add_autoload_singleton(autoload_name, autoload_path)

func _exit_tree():
	remove_autoload_singleton(autoload_name)
