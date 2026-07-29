extends Node3D

const MENU_SCENE = preload("uid://brd6re0074l28")
const GAMEPLAY_SCENE = preload("uid://dvxt4pm66qrq8")

func _ready():
	change_to_menu_scene()

func change_to_menu_scene():
	switch_to_scene(MENU_SCENE)

func change_to_gameplay_scene():
	switch_to_scene(GAMEPLAY_SCENE)

func switch_to_scene(scene : PackedScene):
	for child in get_children():
		child.queue_free()

	var new_scene = scene.instantiate()
	add_child(new_scene)
