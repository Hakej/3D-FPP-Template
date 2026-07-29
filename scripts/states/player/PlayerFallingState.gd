extends PlayerState
class_name PlayerFallingState

@export_category("States")
@export var player_idle_state : PlayerIdleState

@export_category("Exportables")
@export var landing_effect_scene : PackedScene 

func process_state(delta):
	if body.is_on_floor():
		change_state(player_idle_state)
		return
	
	body.velocity.y -= body.gravity * delta
	
	var target_velocity = direction * body.max_speed
	
	if Input.is_action_pressed("run"):
		target_velocity *= body.run_multiplier
	
	body.velocity.x = lerp(body.velocity.x, target_velocity.x, body.speed_smoothing * delta)
	body.velocity.z = lerp(body.velocity.z, target_velocity.z, body.speed_smoothing * delta)
