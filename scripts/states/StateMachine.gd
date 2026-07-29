extends Node
class_name StateMachine

@export_category("Exportables")
@export var default_state : State
@export var animation_tree : AnimationTree

var current_state : State :
	set(new_current_state):
		if current_state:
			current_state.leave_state()
			current_state.set_process_input(false)
		
		current_state = new_current_state
		current_state.set_process_input(true)
		current_state.enter_state()
		current_state.process_state(0)

func _ready():
	if not is_multiplayer_authority():
		set_physics_process(false)
		return
	
	current_state = default_state

func _physics_process(delta):
	current_state.process_state(delta)
