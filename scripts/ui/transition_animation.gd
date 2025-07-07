class_name TransitionAnimation
extends CanvasLayer

#signal finished

var player: Player = null
var target_scene := String()
var target_position := Vector2()
var target_direction := Enums.Direction.Down

@onready var anim_player := $AnimationPlayer as AnimationPlayer

func start(player_: Player, target_scene_: String, target_position_: Vector2, target_direction_: Enums.Direction) -> void:
	player = player_
	target_scene = target_scene_
	target_position = target_position_
	target_direction = target_direction_
	
	anim_player.play(&"transition")
	

#func play_anim_in() -> void:
#	anim_player.play(&"transition", -1, anim_player.speed_scale, true)
#	anim_player.speed_scale *= -1.0
	

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if anim_player.speed_scale > 0.0:
		get_tree().current_scene.remove_child(player)
		get_tree().change_scene_to_file(target_scene)
		get_tree().process_frame.connect(finish_transition, CONNECT_ONE_SHOT)
	else:
		(get_tree().current_scene as BaseScene).finish_transition_to()
		PlayerStateSubsystem.pop_block_movement_source()
		PlayerStateSubsystem.pop_disable_collision_source()
		queue_free()


func finish_transition() -> void:
	get_tree().current_scene.add_child(player)
	player.global_position = target_position
	player.face = target_direction
	
	anim_player.play(&"transition", -1, anim_player.speed_scale, true)
	anim_player.speed_scale *= -1.0
