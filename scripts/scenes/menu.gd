extends Control

var can_move := false
var cursor_pos := 0

@onready var cursor := $Cursor as ColorRect
@onready var cursor_start_y := cursor.position.y

@onready var anim_player_select := $AnimationPlayerSelect as AnimationPlayer
@onready var anim_player_fade := $AnimationPlayerFadein as AnimationPlayer

func _ready() -> void:
	HUD.push_hide_hud_source()
	
	if not FileAccess.file_exists("user://save1.dat"):
		($Options/Options/OptionContinue as Label).modulate.a = 0.5
	
	
func _process(_delta: float) -> void:
	if can_move:
		var updown := int(Input.is_action_just_pressed(&"ui_down")) - int(Input.is_action_just_pressed(&"ui_up"))
		if updown != 0:
			move_cursor(updown)
		elif Input.is_action_just_pressed(&"ui_select"):
			anim_player_select.play(&"select")
			anim_player_fade.play_backwards(&"fadein")
			can_move = false
		
	

func move_cursor(direction: int) -> void:
	cursor_pos = wrapi(cursor_pos + direction, 0, 5)
	cursor.position.y = cursor_start_y + 11 * cursor_pos


func _on_animation_player_fadein_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"fadein":
		can_move = true
