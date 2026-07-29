extends AudioStreamPlayer
class_name HKJAudioStreamPlayer

@export var fade_duration := 1.0
@export var volume := 0.0

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -40.0, fade_duration)
	tween.finished.connect(func(): stop())
	
func fade_in():
	volume_db = -40.0
	play()

	var tween = create_tween()
	tween.tween_property(self, "volume_db", volume, fade_duration)
