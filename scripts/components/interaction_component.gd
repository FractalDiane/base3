class_name InteractionComponent
extends Node

signal interaction_started()
signal interaction_finished()

@export var interaction_event: InkStoryCompiled = null
@export var interaction_selector: InkStoryCompiled = null

@export var text_box_position := Rect2i()
