@tool
extends Node

func get_child_of_type(node, type_ref, is_recursive : bool = false):
	for child in node.get_children():
		
		if is_instance_of(child, type_ref):
			return child
		
		if is_recursive:
			var result = get_child_of_type(child, type_ref, true)
			if result != null:
				return result
	
	return null

func tween(object : Object, property : NodePath, amount : Variant, duration : float, wait : bool = false):
	if object == null:
		return
	
	var tween_object = create_tween()
	tween_object.tween_property(object, property, amount, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	if wait:
		await tween_object.finished

func print_authority_info(node):
	print("#####")
	print("perspective: " + str(node.multiplayer.get_unique_id()))
	print("node of: " + str(node.get_multiplayer_authority()))
	print("has authority: " + str(node.is_multiplayer_authority()))
	print("is server: " + str(node.multiplayer.is_server()))
	print("^^^^^")

func get_random_index(array : Array):
	return randi_range(0, array.size() - 1)

func wait_random_time(min_time : float, max_time : float):
	await get_tree().create_timer(randf_range(min_time, max_time)).timeout

func wait_time(time : float):
	await get_tree().create_timer(time).timeout
