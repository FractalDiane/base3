@tool
class_name Prop
extends StaticBody2D

@export var z_index_offset := 0

@onready var sprite := find_children("*", "Sprite2D", false)[0] as Sprite2D

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		z_index = int(global_position.y) + z_index_offset
	else:
		set_process(false)
