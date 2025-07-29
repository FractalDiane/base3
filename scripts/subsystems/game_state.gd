extends Node

signal flag_added(uid: int)

const SAVE_UI := preload("res://prefabs/ui/save_ui.tscn")

var player_life := 10
var player_corr := 0

var flags := {}

func damage_player(by: int) -> void:
	player_life -= by
	
	
func corrupt_player(by: int) -> void:
	player_corr += by

###############################################################################

const SAVE_VERSION := 0

func save_game() -> void:
	var save_file := FileAccess.open("user://save1.dat", FileAccess.WRITE)
	if save_file != null:
		save_file.store_8(SAVE_VERSION)
		
		save_file.store_8(player_life)
		save_file.store_8(player_corr)
		
		save_file.store_var(flags, false)
		
		save_file.close()
		
	var save_ui := SAVE_UI.instantiate() as CanvasLayer
	get_tree().root.add_child(save_ui)

###############################################################################

func get_flag_uid(flag_partial_path: String) -> int:
	return ResourceLoader.get_resource_uid("res://resources/flags/" + flag_partial_path + ".tres")

	
func has_flag_by_name(flag_path: String) -> bool:
	var uid := get_flag_uid(flag_path)
	return flags.has(uid)


func flag_count_by_name(flag_path: String) -> int:
	var uid := get_flag_uid(flag_path)
	return flags.get(uid, 0)
	
	
func has_minimum_flag_count_by_name(flag_path: String, count: int) -> bool:
	return flag_count_by_name(flag_path) >= count

		
func add_flag_by_name(flag_path: String) -> void:
	var uid := get_flag_uid(flag_path)
	if flags.has(uid):
		flags[uid] += 1
	else:
		flags[uid] = 1
		
	flag_added.emit(uid)
	
		
func remove_flag_by_name(flag_path: String) -> void:
	var uid := get_flag_uid(flag_path)
	flags[uid] -= 1
	if flags[uid] == 0:
		flags.erase(uid)
