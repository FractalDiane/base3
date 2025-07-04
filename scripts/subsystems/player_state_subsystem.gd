extends Node

signal block_movement_changed(state: bool)
signal disable_collision_changed(state: bool)

var block_movement_sources := 0
var disable_collision_sources := 0

func push_block_movement_source() -> void:
	block_movement_sources += 1
	block_movement_changed.emit(block_movement_sources > 0)
	
	
func pop_block_movement_source() -> void:
	block_movement_sources -= 1
	block_movement_changed.emit(block_movement_sources > 0)
	if block_movement_sources < 0:
		push_error("Imbalanced pop_block_movement_source call")
		block_movement_sources = 0


func push_disable_collision_source() -> void:
	disable_collision_sources += 1
	disable_collision_changed.emit(disable_collision_sources > 0)
	
	
func pop_disable_collision_source() -> void:
	disable_collision_sources -= 1
	disable_collision_changed.emit(disable_collision_sources > 0)
	if disable_collision_sources < 0:
		push_error("Imbalanced pop_disable_collision_source call")
		disable_collision_sources = 0


func is_movement_blocked() -> bool:
	return block_movement_sources > 0


func is_collision_disabled() -> bool:
	return disable_collision_sources > 0
