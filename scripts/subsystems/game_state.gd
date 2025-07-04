extends Node

var player_life := 10
var player_corr := 0

func damage_player(by: int) -> void:
	player_life -= by
	
func corrupt_player(by: int) -> void:
	player_corr += by
