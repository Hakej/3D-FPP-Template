extends Node
class_name State

var state_machine : StateMachine
var body : HKJCharacterBody3D

func _ready():
	var parent = get_parent() as StateMachine
	
	if parent:
		state_machine = parent
	
	var character_body = get_parent().get_parent()
	
	if character_body:
		body = character_body
	
	set_process_input(false)

func enter_state():
	pass

func process_state(_delta):
	pass

func leave_state():
	pass

func change_state(new_state : State):
	state_machine.current_state = new_state
