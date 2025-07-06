class_name EventSelector
extends RefCounted

var selector_script: InkStoryCompiled = null

func _init(script: InkStoryCompiled) -> void:
	selector_script = script
	

func select_event() -> String:
	var story := InkStory.new()
	story.load_compiled_file(selector_script)
	Utils.bind_ink_externals(story, false)
	
	var result := story.continue_story()
	result = result.strip_edges()
	if result != "NONE":
		return "res://dialogue/" + result
	else:
		return String()
