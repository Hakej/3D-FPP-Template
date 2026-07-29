extends PlayerState
class_name PlayerRunState

@export_category("States")
@export var player_idle_state : PlayerIdleState
@export var player_walk_state : PlayerWalkState
@export var player_falling_state : PlayerFallingState

func process_state(delta):
	if not body.is_on_floor():
		change_state(player_falling_state)
		return true
	
	if not input_dir:
		change_state(player_idle_state)
		return true
	
	if not Input.is_action_pressed("run"):
		change_state(player_walk_state)
		return true
	
	var target_velocity = direction * body.max_speed * body.run_multiplier
	body.velocity.x = lerp(body.velocity.x, target_velocity.x, body.speed_smoothing * delta)
	body.velocity.z = lerp(body.velocity.z, target_velocity.z, body.speed_smoothing * delta)
	
	if Input.is_action_pressed("jump"):
		body.velocity.y = body.jump_velocity
