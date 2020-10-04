extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

onready var player = get_node("/root/World/YSort/Player")

var interactable = true
var talkable = true
var examined = false

var speaker = "Skeleton: "

func talk():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"Hello.",
		"As you can see, I am a skeleton.",
		"Unless, of course, you can't see.",
		"In which case...",
		"I'm still a skeleton."
	]
	dialogBox.speakerName = str(speaker)
	for x in range(0, dialogBox.dialog.size()):
		dialogBox.dialog[x] = str(speaker + dialogBox.dialog[x])
	get_node("/root/World/GUI").add_child(dialogBox)
	player.talkTimer.start()
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"A friendly looking skeleton.",
		"Actually, you can't tell the difference between rude and friendly skeletons, so you can't be sure."
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	player.talkTimer.start()
	
	if !examined: examined = true

func _on_SkeletonTalkBox_area_entered(_area):
	player.talking = true

func _on_SkeletonTalkBox_area_exited(_area):
	player.talking = false
