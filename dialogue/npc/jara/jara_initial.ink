INCLUDE dialogue/funcs.ink

{ flag_count("npc/jara/talk_count"):
- 0:
	Hello.
	I am Jara.
	What's your name?
	...
	You won't tell me?
	That's fine.
- 1:
	Some strange things have been happening in the manor.
	Lots of people have talked about it.
	Have you heard?
	...
	No?
	That's probably fine.
- 2:
	I saw someone walk into that shed earlier.
	They had [color=\#ff6600]orange[/color] eyes.
	I swear they turned and looked at me for a moment.
	And for the split second that they did,
	It almost felt like my whole body was shattering apart.
	But I'm sure it was just my imagination.
- else:
	Would you like further insight?
	...
	No?
	That's fine.
}

~ add_flag("npc/jara/talk_count")
