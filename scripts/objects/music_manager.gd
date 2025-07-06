class_name MusicManager
extends Node

@export var new_music: AudioStream = null

func _ready() -> void:
	MusicSubsystem.change_music(new_music)
