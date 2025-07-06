class_name InteractionComponent
extends Node

signal interaction_started(player_direction: Enums.Direction)
signal interaction_finished()

@export var interaction_event: InkStoryCompiled = null
@export var interaction_selector: InkStoryCompiled = null

@export var text_box_position := Rect2i()

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
