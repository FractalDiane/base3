class_name EventTriggerVolume
extends Area2D

@onready var interaction_component := $InteractionComponent as InteractionComponent

func _on_body_entered(body: Node2D) -> void:
	if not PlayerStateSubsystem.is_movement_blocked():
		interaction_component.interact(Enums.Direction.Down)
