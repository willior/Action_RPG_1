extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

onready var player = get_parent().get_node("Player")

var interactable = false
var talkable = false
var speaker = "Skeleton: "

func _process(delta):
	# skeleton talk
	if (talkable && Input.is_action_pressed("attack") && player.talkTimer.is_stopped()):
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
		
	# skeleton examine
	if (interactable && Input.is_action_pressed("examine") && player.talkTimer.is_stopped()):
		var dialogBox = DialogBox.instance()
		dialogBox.dialog = [
			"A friendly looking skeleton.",
			"Actually, you can't tell the difference between rude and friendly skeletons, so you can't be sure."
		]
		get_node("/root/World/GUI").add_child(dialogBox)
		player.talkTimer.start()

func _on_SkeletonTalkBox_area_entered(area):
	player.talking = true
	player.interacting = true
	talkable = true
	interactable = true
	$AudioCursHi.play()

func _on_SkeletonTalkBox_area_exited(area):
	player.talking = false
	player.interacting = false
	talkable = false
	interactable = false
