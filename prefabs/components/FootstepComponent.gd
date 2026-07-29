extends Node3D
class_name FootstepComponent

@export var pitch_randomness = 0.1

@export var sounds : Array[AudioStream]

@onready var asp = $ASP
@onready var player = $".."

func make_footstep():
	var current_speed = player.horizontal_velocity.length()
	var walk_speed = player.max_speed
	var run_speed = player.max_speed * player.run_multiplier
	
	var volume = 0.0
	if current_speed <= walk_speed + 0.01:
		volume = lerpf(-35, -25, current_speed / walk_speed)
	else:
		volume = lerpf(-5, 0, current_speed / run_speed)
	asp.volume_db = volume
	
	asp.stream = sounds.pick_random()
	asp.pitch_scale = randf_range(1.0 - pitch_randomness, 1.0 + - pitch_randomness)
	asp.play()

func _on_head_bob_component_step():
	make_footstep()
