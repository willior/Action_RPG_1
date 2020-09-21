extends RichTextLabel

var dialog = [
	"Hello.",
	"Or good evening.",
	"Whatever."
	]
	
var dialogTest = [] setget set_dialog

var dialog_index = 0

func _ready():
	set_bbcode(dialog[dialog_index])
	set_visible_characters(0)
	set_process_input(true)
	
func set_dialog(value):
	pass
	
func _input(event):
	if Input.is_action_just_pressed("attack"):
		if (get_visible_characters() > get_total_character_count() && dialog_index >= dialog.size()-1):
			get_parent().queue_free()
			
		# if the amount of visible characters is above the total amount of characters in the current index:
		elif get_visible_characters() > get_total_character_count():
			# if the number of dialog_indexes in the array is less than the total amount in the array
			if dialog_index < dialog.size()-1:
				# advancing the dialog_index
				dialog_index += 1
				# setting the dialog
				set_bbcode(dialog[dialog_index])
				set_visible_characters(0)
		# if the amount of visible characters is less than the total amount of characters:
		else:
			# displays all the characters in the current dialog_index
			set_visible_characters(get_total_character_count())
			
	if Input.is_action_just_pressed("roll"):
		print(get_visible_characters())
		print(get_total_character_count())

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)
