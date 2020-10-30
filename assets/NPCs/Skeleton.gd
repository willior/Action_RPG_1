extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

onready var sprite = $KinematicBody2D/Sprite

var interactable = false
var talkable = true
var examined = false
var dialog_index = 0
var examine_index = 0

var speaker = "Skeleton: "

func ready():
	sprite.frame = 1

func talk():
	var dialogBox = DialogBox.instance()
	match dialog_index:
		0:
			dialogBox.dialog = [
				"Hello.",
				"As you can see, I am a skeleton.",
				"Unless, of course, you can't see.",
				"In which case...",
				"I'm still a skeleton.",
				"Hahahahahahaha!!"
			]
			dialog_index += 1
		1:
			dialogBox.dialog = [
				"Oh. You again.",
				"Like you, I do not know why I exist.",
				"...",
				"I suppose that was a bit rude of me to assume.",
				"Don't take it personally!",
				"Hahahahahahaha!!"
			]
			dialog_index = 0
			examine_index = 1
	
	dialogBox.speakerName = str(speaker)
	for x in range(0, dialogBox.dialog.size()):
		dialogBox.dialog[x] = str(speaker + dialogBox.dialog[x])
	get_node("/root/World/GUI").add_child(dialogBox)
	
func examine():
	var dialogBox = DialogBox.instance()
	match examine_index:
		0:
			dialogBox.dialog = [
				"A friendly looking skeleton.",
				"Actually, you can't tell the difference between rude and friendly skeletons, so you can't be sure."
			]
		1:
			dialogBox.dialog = [
				"A friendly looking skeleton.",
				"But it turns out he's pretty rude."
			]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true
