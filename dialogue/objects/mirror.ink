INCLUDE dialogue/funcs.ink

{ not has_flag("objects/used_any_mirror"):
	Take a moment to reflect.
	~ add_flag("objects/used_any_mirror")
	
	#wait 1
	@
}


~ save_game()
