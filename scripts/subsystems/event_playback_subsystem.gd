extends Node

func play_event(event: InkStoryCompiled, caller: Node) -> EventPlayer:
	if event != null:
		var player := EventPlayer.new(event, caller)
		get_tree().current_scene.add_child(player)
		
		PlayerStateSubsystem.push_block_movement_source()
		
		player.event_finished.connect(_on_event_finished)
		return player
	else:
		return null

func _on_event_finished(_event: InkStoryCompiled, play_next: String) -> void:
	PlayerStateSubsystem.pop_block_movement_source()
	if not play_next.is_empty():
		play_event(load("res://dialogue/" + play_next), null)
