extends PlayerState
class_name PlayerIdleState

@export_category("States")
@export var player_walk_state : PlayerWalkState
@export var player_falling_state : PlayerFallingState

func process_state(delta):
	if not body.is_on_floor():
		change_state(player_falling_state)
		return
	
	if input_dir:
		change_state(player_walk_state)
		return
	
	body.velocity.x = lerp(body.velocity.x, 0.0, body.speed_smoothing * delta)
	body.velocity.z = lerp(body.velocity.z, 0.0, body.speed_smoothing * delta)
	
	if Input.is_action_pressed("jump"):
		body.velocity.y = body.jump_velocity
