extends Node
class_name HeadBobComponent

signal step

@export var camera: Camera3D

@export var bob_speed: float = 8.0
@export var bob_amount: float = 0.05
@export var return_speed: float = 10.0

var bob_time: float = 0.0
var initial_position: Vector3

var was_below_threshold := false

@onready var player: CharacterBody3D = get_parent()

func _ready():
	initial_position = camera.position

func _process(delta: float):
	var horizontal_speed := Vector2(
		player.velocity.x,
		player.velocity.z
	).length()

	if horizontal_speed > 0.1 and player.is_on_floor():
		bob_time += delta * bob_speed * horizontal_speed * 0.75

		var bob_value := sin(bob_time)

		camera.position.y = initial_position.y + bob_value * bob_amount
		camera.position.x = initial_position.x + cos(bob_time * 0.5) * bob_amount * 0.5

		# Detect the bottom of the bob cycle
		var below_threshold := bob_value < -0.95

		if below_threshold and not was_below_threshold:
			step.emit()

		was_below_threshold = below_threshold
	else:
		camera.position = camera.position.lerp(
			initial_position,
			delta * return_speed
		)

		was_below_threshold = false
