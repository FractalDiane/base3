extends Node

var player_life := 10
var player_corr := 0

var flags := {}

func damage_player(by: int) -> void:
	player_life -= by
	
func corrupt_player(by: int) -> void:
	player_corr += by

func has_flag(flag: Flag) -> bool:
	return flags.has(flag)
	
	
func has_flag_by_name(flag_path: String) -> bool:
	var flag := load("res://resources/flags/" + flag_path + ".tres") as Flag
	return has_flag(flag)
	
func has_n_flag_copies(flag: Flag, copies: int) -> bool:
	return flags.get(flag, 0) >= copies

func add_flag(flag: Flag) -> void:
	if flags.has(flag):
		flags[flag] += 1
	else:
		flags[flag] = 1
		
func add_flag_by_name(flag_path: String) -> void:
	var flag := load("res://resources/flags/" + flag_path + ".tres") as Flag
	add_flag(flag)

func remove_flag(flag: Flag) -> void:
	flags[flag] -= 1
	if flags[flag] == 0:
		flags.erase(flag)
		
func remove_flag_by_name(flag_path: String) -> void:
	var flag := load("res://resources/flags/" + flag_path + ".tres") as Flag
	remove_flag(flag)

func remove_all_flag_copies(flag: Flag) -> void:
	flags.erase(flag)
