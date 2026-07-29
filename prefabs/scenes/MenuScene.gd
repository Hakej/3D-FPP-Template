extends Node3D
class_name MenuScene

func _on_start_game_button_pressed():
	SceneManager.change_to_gameplay_scene()

func _on_exit_game_button_pressed():
	get_tree().quit()
