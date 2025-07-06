class_name InteractionComponent
extends Node

signal focused()
signal unfocused()
signal interaction_started(player_direction: Enums.Direction)
signal interaction_finished()

@export var interaction_area: Area2D = null

@export var interaction_event: InkStoryCompiled = null
@export var interaction_selector: InkStoryCompiled = null

@export var text_box_position := Rect2i()

###############################################################################

func _ready() -> void:
	if interaction_area != null:
		interaction_area.area_entered.connect(_on_interaction_area_area_entered)
		interaction_area.area_exited.connect(_on_interaction_area_area_exited)


func interact(player_direction: Enums.Direction) -> void:
	var event: EventPlayer = null
	if interaction_selector != null:
		var selector := EventSelector.new(interaction_selector)
		var selected := selector.select_event()
		if not selected.is_empty():
			var story := load(selected) as InkStoryCompiled
			event = EventPlaybackSubsystem.play_event(story, self, text_box_position)
	else:
		event = EventPlaybackSubsystem.play_event(interaction_event, self, text_box_position)
		
	if event != null:
		event.event_finished.connect(interaction_finished.emit.unbind(2))
		interaction_started.emit(player_direction)


func _on_interaction_area_area_entered(_area: Area2D) -> void:
	focused.emit()


func _on_interaction_area_area_exited(_area: Area2D) -> void:
	unfocused.emit()
