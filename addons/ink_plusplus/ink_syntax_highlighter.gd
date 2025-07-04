@tool
extends EditorSyntaxHighlighter

const KEYWORDS: Array[String] = [
	"VAR",
	"CONST",
	"LIST",
	"EXTERNAL",
	"INCLUDE",
]

var background_color: Color
var text_color: Color
var selection_color: Color
var comment_color: Color
var symbol_color: Color
var keyword_color: Color
var function_color: Color
var function_definition_color: Color
var base_type_color: Color

var in_block_comment := false

# /////////////////////////////////////////////////////////////////////////////////////////////////

func _get_name() -> String:
	return "Ink"
	
func _get_supported_languages() -> PackedStringArray:
	return ["TextFile"]
	
# /////////////////////////////////////////////////////////////////////////////////////////////////
	
func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var text_edit := get_text_edit()
	if text_edit == null:
		return {}
		
	var line_text := text_edit.get_line(line)
		
	setup_colors()
	var result := {}
	
	var found_any_chars := false
	var found_knot_leader := false
	var in_logic := false
	
	result[0] = {"color": comment_color if in_block_comment else text_color}
	for i in range(len(line_text)):
		# comments/todos
		if text_is_next(line_text, i, "//") or text_is_next(line_text, i, "TODO"):
			result[i] = {"color": comment_color}
			break
			
		#if text_is_next(line_text, i, "/*"):
			#result[i] = {"color": comment_color}
			#in_block_comment = true
			#
		#if text_is_next(line_text, i, "*/"):
			#in_block_comment = false
			
		# knots
		if not in_block_comment and not found_any_chars and text_is_next(line_text, i, "="):
			i += 1
			if text_is_next(line_text, i, "="):
				i += 1
				if text_is_next(line_text, i, "="):
					i += 1
				
				result[i] = {"color": function_definition_color}
			else:
				i += 1
				result[i] = {"color": function_definition_color}
				
			while line_text.unicode_at(i) <= 32:
				i += 1
				
			if text_is_next(line_text, i, "function"):
				var length := len("function")
				result[i] = {"color": keyword_color}
				result[i + length] = {"color": text_color}
				
				i += length
				result[i] = {"color": function_definition_color}
				
			while i < len(line_text) and not text_is_next(line_text, i, "(") and not text_is_next(line_text, i, "="):
				i += 1
			
			result[i] = {"color": text_color}
			
			while i < len(line_text):
				if text_is_next(line_text, i, "ref "):
					result[i] = {"color": keyword_color}
					result[i + 3] = {"color": text_color}
					i += 3
					
				if text_is_next(line_text, i, "="):
					result[i] = {"color": text_color}
					break
					
				i += 1
				
			break
			
		# logic
		if not found_any_chars and text_is_next(line_text, i, "~"):
			result[i] = {"color": symbol_color}
			in_logic = true

		# keywords
		if not in_logic:
			for kw in KEYWORDS:
				if not found_any_chars and text_is_next(line_text, i, kw):
					result[i] = {"color": keyword_color}
					result[i + len(kw)] = {"color": text_color}
			
		if not found_any_chars and line_text.unicode_at(i) > 32:
			found_any_chars = true
	
	return result
	
# /////////////////////////////////////////////////////////////////////////////////////////////////

func setup_colors() -> void:
	var plugin := EditorPlugin.new()
	var settings := plugin.get_editor_interface().get_editor_settings()
	
	background_color = settings.get_setting("text_editor/theme/highlighting/background_color")
	text_color = settings.get_setting("text_editor/theme/highlighting/text_color")
	selection_color = settings.get_setting("text_editor/theme/highlighting/selection_color")
	comment_color = settings.get_setting("text_editor/theme/highlighting/comment_color")
	symbol_color = settings.get_setting("text_editor/theme/highlighting/symbol_color")
	keyword_color = settings.get_setting("text_editor/theme/highlighting/keyword_color")
	function_color = settings.get_setting("text_editor/theme/highlighting/function_color")
	function_definition_color = settings.get_setting("text_editor/theme/highlighting/gdscript/function_definition_color")
	base_type_color = settings.get_setting("text_editor/theme/highlighting/base_type_color")
	
	plugin.free()

func text_is_next(src: String, index: int, what: String) -> bool:
	for i in range(len(what)):
		if index + i >= len(src):
			return false
		
		if src[index + i] != what[i]:
			return false
			
	return true
