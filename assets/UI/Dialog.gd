extends RichTextLabel

var dialog = ["Hello.", "Or good evening.", "Whatever."]

var page = 0

func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)
	set_process_input(true)
	
func _input(event):
	if Input.is_action_just_pressed("attack"):
		pass

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)
