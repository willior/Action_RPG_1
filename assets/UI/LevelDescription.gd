extends Control

onready var label = $RichTextLabel
var description : String

func update_description(text):
	label.bbcode_text = text
	#label.set_visible_characters(0)
	#$TimerText.start()

func _on_ButtonVIT_focus_entered():
	# show()
	description = "Willpower is a measure of your ability to press on through hardship, or how much you are willing to withstand."
	update_description(description)

func _on_ButtonEND_focus_entered():
	description = "Lung Capacity determines how many physical actions you can perform in a short period of time."
	update_description(description)

func _on_ButtonDEF_focus_entered():
	description = "Resilience makes things easier for you when hardship is inevitable, as well as helps in maintaining your composure."
	update_description(description)

func _on_ButtonSTR_focus_entered():
	description = "Violent Nature is a measure of how much pain you are willing to inflict on others, for survival or otherwise."
	update_description(description)

func _on_ButtonDEX_focus_entered():
	description = "Patience allows for careful observation of threats, augmenting accuracy and the frequency of critical strikes."
	update_description(description)

func _on_ButtonSPD_focus_entered():
	description = "Swiftness aids in reflexive maneuvers like evasion, as well as the speed with which certain actions are performed."
	update_description(description)
	
func _on_ButtonMAG_focus_entered():
	description = "Spirituality governs the amount of aid received from higher planes, as well as one's grasp of the incomprehensible."
	update_description(description)
	
func _on_TimerText_timeout():
	if label.get_visible_characters() <= label.get_total_character_count():
		#$AudioStreamPlayer.play()
		label.set_visible_characters(label.get_visible_characters()+1)
	else:
		#$AudioStreamPlayer.stop()
		$TimerText.stop()
		# $Text/Sprite.show()
		# finished = true
