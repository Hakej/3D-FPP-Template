@tool
extends EditorPlugin

var button

func _enter_tree():
	button = Button.new()
	button.text = "Create Node Dirs"
	button.pressed.connect(_on_pressed)
	
	add_control_to_container(CONTAINER_TOOLBAR, button)

func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, button)
	button.free()

func _on_pressed():
	var dialog = AcceptDialog.new()
	dialog.title = "Enter folder name"

	var input = LineEdit.new()
	dialog.add_child(input)

	dialog.confirmed.connect(func():
		var name = input.text.strip_edges()
		if name != "":
			_create_dirs(name)
	)

	get_editor_interface().get_base_control().add_child(dialog)
	dialog.popup_centered()

func _create_dirs(name: String):
	var paths = [
		"res://prefabs/%s" % name,
		"res://scripts/%s" % name
	]

	for path in paths:
		if not DirAccess.dir_exists_absolute(path):
			DirAccess.make_dir_recursive_absolute(path)
			print("Created: ", path)
