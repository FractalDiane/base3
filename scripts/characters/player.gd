class_name Player
extends CharacterBody2D

@export var speed := 50.0

const DIR_ANIMATIONS: Array[String] = [
	"up",
	"down",
	"left",
	"right",
]

const DIR_ROTATIONS: Array[float] = [
	-180.0,
	0.0,
	90.0,
	-90.0,
]

enum Direction {
	Up,
	Down,
	Left,
	Right,
}

var motion := Vector2()
var face := Direction.Down

@onready var sprite := $Sprite as AnimatedSprite2D
@onready var sight := $Sight as Area2D
@onready var collision := $CollisionShape2D as CollisionShape2D

###############################################################################

func _ready() -> void:
	PlayerStateSubsystem.disable_collision_changed.connect(_on_disable_collision_changed)
	
	
func _process(_delta: float) -> void:
	direction_management()
	_animate_sprite()
	
	z_index = int(global_position.y)
	
	
func _physics_process(_delta: float) -> void:
	if not PlayerStateSubsystem.is_movement_blocked():
		motion.x = Input.get_axis(&"move_left", &"move_right")
		motion.y = Input.get_axis(&"move_up", &"move_down")
		
		velocity = motion.normalized() * speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
	
func set_collision_enabled(enabled: bool) -> void:
	collision.disabled = not enabled
	

func direction_management() -> void:
	if motion.x == 0:
		match motion.y:
			-1.0:
				face = Direction.Up
			1.0:
				face = Direction.Down
	elif motion.y == 0:
		match motion.x:
			-1.0:
				face = Direction.Left
			1.0:
				face = Direction.Right
				
	sight.rotation_degrees = DIR_ROTATIONS[face]
				
				
func _animate_sprite() -> void:
	var anim := DIR_ANIMATIONS[face] as String
	
	#if motion.length_squared() != 0.0:
	#	anim += "_walk"
		
	sprite.play(anim)

func _on_disable_collision_changed(disable: bool) -> void:
	collision.disabled = disable
