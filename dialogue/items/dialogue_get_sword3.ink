INCLUDE dialogue/funcs.ink
CONST flag = "objects/got_sword3"

{has_flag(flag): -> END}

~ get_item_animation("Sprite2D")
#wait 1
You got the THREE SWORD.
Press [SPACE] to attack.
~ add_flag(flag)
