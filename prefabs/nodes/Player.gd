extends HKJCharacterBody3D
class_name Player

@export_category("Movement")
@export var mouse_sensitivity = 0.002
@export var camera_reset_speed := 5.0

@export_group("Local")
@export var camera : Camera3D

var rotation_x = 0.0
var camera_yaw = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta: float) 	-> void:
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			camera_yaw -= event.relative.x * mouse_sensitivity
		else:
			rotate_y(-event.relative.x * mouse_sensitivity)

		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-90), deg_to_rad(90))
		camera.rotation.y = camera_yaw
		camera.rotation.x = rotation_x
