class_name ConditionalComponent
extends Node

@export var flags_required: Array[FlagRequirement] = []

func _ready() -> void:
	for flag in flags_required:
		if GameState.has_n_flag_copies(flag.flag, flag.copies_required) == flag.invert_requirement:
			get_parent().queue_free()
			return
