class_name LoadingZone
extends Area2D

@export var scrolling := false
@export_file("*.tscn") var target_scene := String()

@onready var collision := $CollisionShape2D as CollisionShape2D

###############################################################################

func _ready() -> void:
	if scrolling:
		ResourceLoader.load_threaded_request(target_scene)
	
###############################################################################

func setup_from_manager(scene: String, normal: Vector2) -> void:
	scrolling = true
	target_scene = scene
	
	var shape := WorldBoundaryShape2D.new()
	shape.normal = normal
	if normal.x < 0.0:
		shape.distance = -192.0
	elif normal.y < 0.0:
		shape.distance = -112.0
	
	($CollisionShape2D as CollisionShape2D).shape = shape


func _on_body_entered(body: Node2D) -> void:
	collision.set_deferred(&"disabled", true)
	PlayerStateSubsystem.push_block_movement_source()
	PlayerStateSubsystem.push_disable_collision_source.call_deferred()
	if scrolling:
		var new_scene_packed := ResourceLoader.load_threaded_get(target_scene)
		var new_scene := (new_scene_packed as PackedScene).instantiate() as BaseScene

		get_tree().root.add_child.call_deferred(new_scene)
		get_tree().root.move_child.call_deferred(new_scene, -2)
		get_tree().set_current_scene.call_deferred(new_scene)

		var shape_normal := (collision.shape as WorldBoundaryShape2D).normal
		var new_scene_position := Vector2(192 * -shape_normal.x, 112 * -shape_normal.y)
		new_scene.position = new_scene_position

		var tween := get_tree().create_tween()
		tween.set_parallel()

		var player := body as Player
		var current_position_player := player.position
		tween.tween_property(player, ^"position", current_position_player + -shape_normal * 16, 1.0)
		
		var old_scene := get_tree().current_scene as BaseScene
		var current_position_scene_from := old_scene.position
		tween.tween_property(old_scene, ^"position", current_position_scene_from - new_scene_position, 1.0)
		
		tween.tween_property(new_scene, ^"position", Vector2.ZERO, 1.0)
		
		tween.finished.connect(_on_scroll_finished.bind(old_scene, new_scene, player))
	else:
		pass

func _on_scroll_finished(old_scene: BaseScene, new_scene: BaseScene, player: Player) -> void:
	var player_global_pos := player.global_position
	old_scene.remove_child(player)
	new_scene.add_child(player)
	player.global_position = player_global_pos
	
	old_scene.queue_free()
	new_scene.finish_transition_to()
	PlayerStateSubsystem.pop_block_movement_source()
	PlayerStateSubsystem.pop_disable_collision_source()
