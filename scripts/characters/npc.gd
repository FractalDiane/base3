class_name NPC
extends CharacterBody2D

const DIRECTION_ANIMATIONS: Array[StringName] = [&"up", &"down", &"left", &"right"]

@export var face_player_on_interact := true
@export var z_index_y_offset := 0

@onready var sprite := $Sprite as AnimatedSprite2D
@onready var interaction_indicator := $InteractionIndicator as AnimatedSprite2D

func _ready() -> void:
	interaction_indicator.hide()
	z_index = int(position.y) + z_index_y_offset
	
	var collision := $CollisionShape2D as CollisionShape2D
	var interact_collision := $InteractionArea/CollisionShape2D as CollisionShape2D
	interact_collision.shape = collision.shape
	interact_collision.position = collision.position


#func _process(_delta: float) -> void:
	#z_index = int(position.y)


func _on_interaction_component_focused() -> void:
	interaction_indicator.frame = 0
	interaction_indicator.play(&"default")
	interaction_indicator.show()


func _on_interaction_component_unfocused() -> void:
	interaction_indicator.hide()
	interaction_indicator.stop()


func _on_interaction_component_interaction_started(player_direction: Enums.Direction) -> void:
	_on_interaction_component_unfocused()
	if face_player_on_interact:
		sprite.play(DIRECTION_ANIMATIONS[int(Enums.get_opposite_direction(player_direction))])


func _on_interaction_component_interaction_finished() -> void:
	_on_interaction_component_focused()
