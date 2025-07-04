class_name LoadingZoneManager
extends Node

const LOADING_ZONE := preload("res://prefabs/objects/loading_zone.tscn")

const DIRECTIONS: Array[Vector2] = [Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT]

@export_file("*.tscn") var scene_up := String()
@export_file("*.tscn") var scene_down := String()
@export_file("*.tscn") var scene_left := String()
@export_file("*.tscn") var scene_right := String()

func _ready() -> void:
	(get_parent() as BaseScene).transitioned_to.connect(run)
			

func run() -> void:
	var scenes: Array[String] = [scene_up, scene_down, scene_left, scene_right]
	for i in range(len(scenes)):
		if not scenes[i].is_empty():
			var loading_zone := LOADING_ZONE.instantiate() as LoadingZone
			loading_zone.setup_from_manager(scenes[i], DIRECTIONS[i])
			get_tree().current_scene.add_child.call_deferred(loading_zone)
			
