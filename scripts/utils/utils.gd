class_name Utils

static func bind_ink_externals(story: InkStory, bind_impure_funcs: bool) -> void:
	story.bind_external_function(&"has_flag", GameState.has_flag_by_name)
	
	if bind_impure_funcs:
		story.bind_external_function(&"add_flag", GameState.add_flag_by_name)
		story.bind_external_function(&"remove_flag", GameState.remove_flag_by_name)
		
	
