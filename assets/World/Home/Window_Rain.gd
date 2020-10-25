extends AnimatedSprite

const DialogBox = preload("res://assets/UI/Dialog.tscn")

onready var player = get_node("/root/World/YSort/Player")

var interactable = false
var talkable = false
var examined = false
var index = 0

func _ready():
# warning-ignore:return_value_discarded
	PlayerLog.connect("home_window_complete", self, "examine_complete")
# warning-ignore:return_value_discarded
	PlayerLog.connect("home_window_advance", self, "advance_dialog_index")
	
	if PlayerLog.home_window_examined:
		examine_complete(true)
	
func examine():
	var dialogBox = DialogBox.instance()
	match index:
		0:
			dialogBox.dialog = [
			"It's really coming down."
			]
			PlayerLog.set_dialog_index("home_window", 1)
		1:
			dialogBox.dialog = [
			"Doesn't look like it's going to stop any time soon."
			]
			PlayerLog.set_dialog_index("home_window", 2)
		2:
			dialogBox.dialog = [
			"The rain isn't usually this tumultuous.",
			"Strange."
			]
			PlayerLog.set_dialog_index("home_window", 0)

			if !PlayerLog.home_window_examined:
				PlayerLog.set_examined("home_window", true)
				PlayerLog.home_window_examined = true
				
	get_node("/root/World/GUI").add_child(dialogBox)
	
func examine_complete(value):
	examined = value

func advance_dialog_index(value):
	index = value
