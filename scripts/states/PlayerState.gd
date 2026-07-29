extends State
class_name PlayerState

var input_dir : Vector2 :
	get:
		return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

var direction : Vector3 :
	get:
		return (body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
