extends CharacterBody3D
class_name HKJCharacterBody3D

@export_category("Exportables")
@export var animation_tree : AnimationTree

var horizontal_velocity = Vector3.ZERO :
	get:
		var vel = velocity
		vel.y = 0.0
		return vel

@export var max_speed : float = 2.25
@export var run_multiplier : float = 2.0
@export var jump_velocity : float = 10
@export var speed_smoothing : float = 8.0
@export var gravity = 9.8
