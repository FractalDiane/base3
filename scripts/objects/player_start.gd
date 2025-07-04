extends Marker2D

const PLAYER := preload("res://prefabs/characters/player.tscn")

func _ready() -> void:
	if get_tree().current_scene == get_parent():
		var player := PLAYER.instantiate() as Player
		player.position = position
		get_tree().current_scene.add_child.call_deferred(player)
		
		(get_tree().current_scene.get_node(^"LoadingZoneManager") as LoadingZoneManager).run()
		
	queue_free()
