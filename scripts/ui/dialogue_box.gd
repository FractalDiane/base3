class_name DialogueBox
extends NinePatchRect

signal text_finished()
signal close_animation_finished()

const REGEX_TAGS := r"\[.+\](.+)\[.+\]"

var open_anim_finished := false
var current_text_finished := false
var closing := false

var regex_tags := RegEx.new()
var text_length_no_tags := 0

@onready var label := $Text as RichTextLabel

@onready var sound_open_1 := $SoundOpen1 as AudioStreamPlayer
@onready var sound_open_2 := $SoundOpen2 as AudioStreamPlayer
@onready var sound_text := $SoundText as AudioStreamPlayer
@onready var sound_text_finished := $SoundTextFinished as AudioStreamPlayer

@onready var timer_text := $TimerText as Timer
@onready var timer_sound_open := $TimerSoundOpen as Timer

func _process(_delta: float) -> void:
	if open_anim_finished and not closing and Input.is_action_just_pressed(&"ui_accept"):
		if not current_text_finished:
			label.visible_characters = text_length_no_tags
			timer_text.stop()
			current_text_finished = true
		else:
			text_finished.emit()


func start(text: String, rect_size := Rect2i()) -> void:
	if not regex_tags.is_valid():
		regex_tags.compile(REGEX_TAGS)
		
	label.visible_characters = 0
	label.text = text
	current_text_finished = false
	
	text_length_no_tags = regex_tags.sub(text, "$1", true).length()
	
	if not open_anim_finished:
		position = rect_size.position
		label.size.x = rect_size.size.x - 12
		label.size.y = rect_size.size.y - 12
		
		var tween := create_tween()
		tween.tween_property(self, ^"size:x", rect_size.size.x, 0.3)
		tween.tween_property(self, ^"size:y", rect_size.size.y, 0.3)
		tween.finished.connect(roll_text)
		sound_open_1.play()
		timer_sound_open.start()
	else:
		roll_text()
		
		
func play_close_animation() -> void:
	label.visible_characters = false
	var tween := create_tween()
	tween.tween_property(self, ^"size:y", 6, 0.3)
	tween.tween_property(self, ^"size:x", 6, 0.3)
	tween.finished.connect(close_animation_finished.emit)
	tween.finished.connect(queue_free)
	sound_open_1.play()
	timer_sound_open.start()
	closing = true
		
		
func roll_text() -> void:
	open_anim_finished = true
	timer_text.start()
	
	
func _on_timer_text_timeout() -> void:
	label.visible_characters += 1
	if label.visible_characters == text_length_no_tags:
		timer_text.stop()
		current_text_finished = true
		sound_text_finished.play()
	elif label.text[label.visible_characters - 1] != ' ':
		sound_text.play()
