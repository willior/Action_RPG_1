extends AnimatedSprite

const DialogBox = preload("res://assets/UI/DialogBox.tscn")

var interactable = false
var talkable = false
var examined = false
var index = 0

func _ready():
# warning-ignore:return_value_discarded
	PlayerLog.connect("home_window_complete", self, "examine_complete")
# warning-ignore:return_value_discarded
	PlayerLog.connect("home_window_advance", self, "advance_dialog_index")
	if name in PlayerLog.examined_list:
		examined = true
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			dialogBox.dialog_script = [
				{'text': "It's really coming down."}
			]
			PlayerLog.set_dialog_index("home_window", 1)
		1:
			dialogBox.dialog_script = [
				{'text': "Doesn't look like it's going to stop any time soon."}
			]
			PlayerLog.set_dialog_index("home_window", 2)
		2:
			dialogBox.dialog_script = [
				{'text': "The rain isn't usually this tumultuous."},
				{'text': "Strange."}
			]
			PlayerLog.set_dialog_index("home_window", 0)
			PlayerLog.set_examined_and_signal("home_window")
				
	get_node("/root/World/GUI").add_child(dialogBox)
	
func examine_complete(value):
	examined = value

func advance_dialog_index(value):
	index = value
