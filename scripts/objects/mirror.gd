class_name Mirror
extends StaticBody2D

@onready var subscene_root := %SubsceneRoot as Node2D

func _ready() -> void:
	subscene_root.position = Vector2(-position.x - 1, -position.y)
