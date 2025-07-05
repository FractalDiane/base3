class_name Enums
extends Node

enum Direction {
	Up,
	Down,
	Left,
	Right,
}

static func get_opposite_direction(direction: Direction) -> Direction:
	match direction:
		Direction.Up:
			return Direction.Down
		Direction.Down:
			return Direction.Up
		Direction.Left:
			return Direction.Right
		_:
			return Direction.Left
