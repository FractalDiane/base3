extends CanvasLayer

@onready var FLAG_SWORD3 := GameState.get_flag_uid("objects/got_sword3")

var hide_hud_sources := 0

@onready var hud_sword := $HUD/Base/Sword as Control

func _ready() -> void:
	GameState.flag_added.connect(_on_flag_added)

func push_hide_hud_source() -> void:
	hide_hud_sources += 1
	if hide_hud_sources > 0:
		hide()
	

func pop_hide_hud_source() -> void:
	hide_hud_sources -= 1
	if hide_hud_sources <= 0:
		show()
		if hide_hud_sources < 0:
			push_error("Imbalanced pop_hide_hud_source call")
			hide_hud_sources = 0

###############################################################################

func _on_flag_added(uid: int) -> void:
	match uid:
		FLAG_SWORD3:
			hud_sword.show()
