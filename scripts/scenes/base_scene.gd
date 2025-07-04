class_name BaseScene
extends Node2D

signal transitioned_to()

func finish_transition_to() -> void:
	transitioned_to.emit()
