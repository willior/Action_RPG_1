extends Polygon2D

var dialog = [
	"Hello.",
	"You are reading the default dialog box message.",
	"You're not supposed to be reading this message.",
	"Something must have gone terribly, terribly wrong.",
	"If only this game was made by a competent programmer..."
	]
	
var dialog_index = 0

onready var label = $RichTextLabel

func _ready():
	
	# sets the text to that contained in the matching dialog_index array container
	label.set_bbcode(dialog[dialog_index])
	label.set_visible_characters(0)
	label.set_process_input(true)
	get_node("/root/World/YSort/Player").talking = true
	get_tree().paused = true
	
func _input(event):
	if Input.is_action_just_pressed("attack") || Input.is_action_just_pressed("examine"):
		# if at the end of the dialog
		if (label.get_visible_characters() > label.get_total_character_count() && dialog_index >= dialog.size()-1):
			get_node("/root/World/YSort/Player").talking = false
			get_tree().paused = false
			queue_free()
			
		# if the amount of visible characters is above the total amount of characters in the current index:
		elif label.get_visible_characters() > label.get_total_character_count():
			# if the number of dialog_indexes in the array is less than the total amount in the array
			if dialog_index < dialog.size()-1:
				# advancing the dialog_index
				dialog_index += 1
				# setting the dialog
				label.set_bbcode(dialog[dialog_index])
				label.set_visible_characters(0)
		# if the amount of visible characters is less than the total amount of characters:
		else:
			# displays all the characters in the current dialog_index
			label.set_visible_characters(label.get_total_character_count())
			
	if Input.is_action_just_pressed("roll"):
		print(label.get_visible_characters())
		print(label.get_total_character_count())

func _on_Timer_timeout():
	if label.get_visible_characters() <= label.get_total_character_count():
		$AudioStreamPlayer.play()
		label.set_visible_characters(label.get_visible_characters()+1)
	else:
		$AudioStreamPlayer.stop()
