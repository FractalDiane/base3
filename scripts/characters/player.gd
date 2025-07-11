class_name Player
extends CharacterBody2D

@export var speed := 50.0
@export var mirror := false

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

var swinging_sword := false

var real_player: Player = null
var mirror_y := 0.0

class InteractibleInSight:
	var interactible: Node2D
	var distance: float
	
	func _init(interactible_: Node2D, distance_: float) -> void:
		interactible = interactible_
		distance = distance_

var interactibles_in_sight: Array[InteractibleInSight] = []

var gotten_item: Sprite2D = null

@onready var sprite := $Sprite as AnimatedSprite2D
@onready var sight := $Sight as Area2D
@onready var got_item_marker := $GotItem as Marker2D
@onready var collision := $CollisionShape2D as CollisionShape2D

@onready var sound_sword := $SoundSword as AudioStreamPlayer
@onready var sound_item := $SoundGotItem as AudioStreamPlayer
@onready var sound_item_short := $SoundGotItemShort as AudioStreamPlayer
@onready var sound_item_shorter := $SoundGotItemShorter as AudioStreamPlayer

###############################################################################

func _ready() -> void:
	PlayerStateSubsystem.disable_collision_changed.connect(_on_disable_collision_changed)
	EventPlaybackSubsystem.event_finished.connect(_on_event_finished)
	
	if mirror:
		mirror_y = get_parent().position.y
		
		var get_player := func(): real_player = get_tree().current_scene.get_node(^"Player")
		get_player.call_deferred()
	
	
func _process(_delta: float) -> void:
	if not swinging_sword and not PlayerStateSubsystem.is_movement_blocked():
		_animate_sprite()
		direction_management()
	
	z_index = int(global_position.y)
	
	
func _physics_process(_delta: float) -> void:
	if not PlayerStateSubsystem.is_movement_blocked() and not swinging_sword:
		motion.x = Input.get_axis(&"move_left", &"move_right")
		motion.y = Input.get_axis(&"move_up", &"move_down")
		if mirror:
			motion.y *= -1
		
		velocity = motion.normalized() * speed
		
		if Input.is_action_just_pressed(&"interact") and not interactibles_in_sight.is_empty():
			(interactibles_in_sight[0].interactible.get_node(^"InteractionComponent") as InteractionComponent).interact(face)
			
		if not swinging_sword and Input.is_action_just_pressed(&"sword"):
			sprite.play(DIR_ANIMATIONS[int(face)] + "_sword")
			sound_sword.play()
			swinging_sword = true
	else:
		motion = Vector2.ZERO
		velocity = Vector2.ZERO
		
	move_and_slide()

	if mirror and real_player != null:
		position.x = real_player.position.x
	

func play_got_item_animation(item: Sprite2D) -> void:
	gotten_item = item
	var tween := create_tween()
	tween.tween_property(item, ^"global_position", round(got_item_marker.global_position - item.texture.get_size() * 0.5), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	PlayerStateSubsystem.push_block_movement_source()
	sprite.play(&"got_item")
	sound_item.play()


func end_got_item_animation() -> void:
	PlayerStateSubsystem.pop_block_movement_source()
	sprite.play(&"down")
	face = Enums.Direction.Down
	gotten_item.queue_free()
	gotten_item = null


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

	
func _on_sight_area_entered(area: Area2D) -> void:
	var body := area.get_parent() as Node2D
	interactibles_in_sight.push_back(InteractibleInSight.new(body, position.distance_squared_to(body.position)))
	interactibles_in_sight.sort_custom(sort_interactibles)


func _on_sight_area_exited(area: Area2D) -> void:
	var body := area.get_parent() as Node2D
	for i in range(len(interactibles_in_sight)):
		if interactibles_in_sight[i].interactible == body:
			interactibles_in_sight.remove_at(i)
			break
			
	interactibles_in_sight.sort_custom(sort_interactibles)
	
	
func sort_interactibles(a: InteractibleInSight, b: InteractibleInSight):
	return a.distance < b.distance
	
	
func start_scroll() -> void:
	sprite.play(DIR_ANIMATIONS[int(face)] + "_walk")
	
	
func end_scroll() -> void:
	sprite.play(DIR_ANIMATIONS[int(face)])
	
	
func _on_event_finished(_event: InkStoryCompiled) -> void:
	if gotten_item != null:
		end_got_item_animation()


func _on_sprite_animation_finished() -> void:
	if sprite.animation.ends_with("sword"):
		swinging_sword = false
