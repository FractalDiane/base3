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

var motion := Vector2()
var face := Enums.Direction.Down

class InteractibleInSight:
	var interactible: Node2D
	var distance: float
	
	func _init(interactible_: Node2D, distance_: float) -> void:
		interactible = interactible_
		distance = distance_

var interactibles_in_sight: Array[InteractibleInSight] = []

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
		
		if Input.is_action_just_pressed(&"interact") and not interactibles_in_sight.is_empty():
			(interactibles_in_sight[0].interactible.get_node(^"InteractionComponent") as InteractionComponent).interact(face)
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
	
func set_collision_enabled(enabled: bool) -> void:
	collision.disabled = not enabled
	

func direction_management() -> void:
	if motion.x == 0:
		match motion.y:
			-1.0:
				face = Enums.Direction.Up
			1.0:
				face = Enums.Direction.Down
	elif motion.y == 0:
		match motion.x:
			-1.0:
				face = Enums.Direction.Left
			1.0:
				face = Enums.Direction.Right
				
	sight.rotation_degrees = DIR_ROTATIONS[face]
	
				
func _animate_sprite() -> void:
	var anim := DIR_ANIMATIONS[face] as String
	
	if motion.length_squared() != 0.0:
		anim += "_walk"
		
	sprite.play(anim)

func _on_disable_collision_changed(disable: bool) -> void:
	collision.disabled = disable


func _on_sight_body_entered(body: Node2D) -> void:
	interactibles_in_sight.push_back(InteractibleInSight.new(body, position.distance_squared_to(body.position)))
	interactibles_in_sight.sort_custom(sort_interactibles)


func _on_sight_body_exited(body: Node2D) -> void:
	for i in range(len(interactibles_in_sight)):
		if interactibles_in_sight[i].interactible == body:
			interactibles_in_sight.remove_at(i)
			break
			
	interactibles_in_sight.sort_custom(sort_interactibles)
	
	
func sort_interactibles(a: InteractibleInSight, b: InteractibleInSight):
	return a.distance < b.distance
