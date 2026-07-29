@tool
extends CanvasLayer
class_name Console

const PRINT_TO_DEFAULT_OUTPUT : bool = true

@export var output : RichTextLabel
@export var input : LineEdit

@export var console_height := 230.0 :
	set(new_console_height):
		console_height = new_console_height
		
		if is_inside_tree():
			apply_styles()

var _commands: Dictionary = {} # String -> Dictionary({ "callable": Callable, "help": String })

var is_shown : bool = false :
	set = set_is_shown

func _ready() -> void:
	apply_styles()
	
	_register_builtin_commands()
	
	offset = Vector2(0.0, -console_height)
	
	if not input.text_submitted.is_connected(_on_input_submitted):
		# Keep focus/editing after hitting Enter.
		input.keep_editing_on_text_submit = true
		input.text_submitted.connect(_on_input_submitted)

func apply_styles():
	$Control/Background.custom_minimum_size.y = console_height
	$Control/GreenDivider.position.y = console_height - 1
	offset.y = -console_height

func _input(event):
	if event is not InputEventKey:
		return
	
	if not event.is_pressed():
		return
	
	if event.physical_keycode == KEY_ESCAPE:
		input.release_focus()
		return
	
	if event.physical_keycode != KEY_QUOTELEFT:
		return
	
	is_shown = !is_shown

func p(text : Variant):
	var current_time = Time.get_time_string_from_system()
	var text_to_print = "[color=#666666][" + current_time + "][/color]: " + str(text)
	
	output.append_text(text_to_print + "\n")
	
	if PRINT_TO_DEFAULT_OUTPUT:
		var basic_text_to_print = str(multiplayer.get_unique_id()) + " -> [" + current_time + "]: " + str(text)
		print(basic_text_to_print)

@rpc("any_peer", "call_local")
func _p(text : Variant):
	p(text)

func set_is_shown(new_is_shown):
	if new_is_shown:
		tween(self, "offset", Vector2(0, 0), 0.1)
		_focus_input_deferred()
	else:
		tween(self, "offset", Vector2(0, -console_height), 0.1)
		input.release_focus()
	
	is_shown = new_is_shown

func tween(object : Object, property : NodePath, amount : Variant, duration : float, wait : bool = false):
	if object == null:
		return
	
	var tween_object = create_tween()
	tween_object.tween_property(object, property, amount, duration).set_trans(Tween.TRANS_CUBIC)

	if wait:
		await tween_object.finished

func add_command(command_name: String, command_callable: Callable, help_text: String = "") -> void:
	var key := command_name.strip_edges()
	if key.is_empty():
		push_warning("Console.add_command called with empty command_name.")
		return
	
	_commands[key] = {
		"callable": command_callable,
		"help": help_text,
	}

func remove_command(command_name: String) -> void:
	_commands.erase(command_name.strip_edges())

func run_command(command_line: String) -> void:
	var line := command_line.strip_edges()
	if line.is_empty():
		return
	
	p("[color=green]> " + line + "[/color]")
	
	var parts := _split_command_line(line)
	if parts.is_empty():
		return
	
	var cmd := parts[0]
	var args := parts.slice(1)
	
	if not _commands.has(cmd):
		p("Unknown command: " + cmd + " (try 'help')")
		return
	
	var entry: Dictionary = _commands[cmd]
	var c: Callable = entry.get("callable", Callable())
	if not c.is_valid():
		p("Command has no callable: " + cmd)
		return
	
	var result := c.call(args)
	if result != null:
		p(result)

func _on_input_submitted(text: String) -> void:
	run_command(text)
	input.clear()
	# Refocus next frame; some UI setups drop focus on submit.
	call_deferred("_focus_input_now")

func _focus_input_deferred() -> void:
	call_deferred("_focus_input_now")

func _focus_input_now() -> void:
	input.grab_focus()

func is_capturing_input() -> bool:
	return is_shown and input.has_focus()

func _register_builtin_commands() -> void:
	add_command("help", func(_args: Array) -> String:
		var names := _commands.keys()
		names.sort()
		var lines: Array[String] = []
		for n in names:
			var help_text: String = (_commands[n] as Dictionary).get("help", "")
			if help_text.is_empty():
				lines.append(n)
			else:
				lines.append(n + " - " + help_text)
		return "Commands:\n" + "\n".join(lines)
	, "List commands")
	
	add_command("clear", func(_args: Array) -> void:
		if output != null:
			output.clear()
	, "Clear console output")

func _split_command_line(line: String) -> PackedStringArray:
	# Minimal parser: supports quotes and backslash escapes.
	var out := PackedStringArray()
	var current := ""
	var in_quotes := false
	var escape := false
	
	for i in line.length():
		var ch := line[i]
		
		if escape:
			current += ch
			escape = false
			continue
		
		if ch == "\\":
			escape = true
			continue
		
		if ch == "\"":
			in_quotes = not in_quotes
			continue
		
		if not in_quotes and (ch == " " or ch == "\t"):
			if not current.is_empty():
				out.append(current)
				current = ""
			continue
		
		current += ch
	
	if not current.is_empty():
		out.append(current)
	
	return out
