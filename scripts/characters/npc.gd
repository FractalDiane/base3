class_name NPC
extends CharacterBody2D

const DIRECTION_ANIMATIONS: Array[StringName] = [&"up", &"down", &"left", &"right"]

@export var face_player_on_interact := true

@onready var sprite := $Sprite as AnimatedSprite2D

func _process(_delta: float) -> void:
	z_index = int(global_position.y)


func _on_interaction_component_interaction_started(player_direction: Enums.Direction) -> void:
	if face_player_on_interact:
		sprite.play(DIRECTION_ANIMATIONS[int(Enums.get_opposite_direction(player_direction))])
