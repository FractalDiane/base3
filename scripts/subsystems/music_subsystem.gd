extends AudioStreamPlayer

func _ready() -> void:
	bus = "Music"

func change_music(music: AudioStream) -> void:
	stream = music
	play()
	
func stop_music() -> void:
	stop()
