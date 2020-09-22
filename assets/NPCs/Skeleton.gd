extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")
const Notice = preload("res://assets/UI/Notice.tscn")

onready var player = get_parent().get_node("Player")
onready var talkTimer = $TalkTimer
onready var collision = $KinematicBody2D/Area2D/CollisionShape2D

func _process(delta):
	# skeleton talk
	if (player.interactable == true && Input.is_action_pressed("attack") && talkTimer.is_stopped()):
		collision.disabled = true
		var dialogBox = DialogBox.instance()
		dialogBox.dialog = [
			"Hello.",
			"As you can see, I am a skeleton.",
			"Unless, of course, you can't see.",
			"In which case...",
			"I'm still a skeleton."
		]
		get_node("/root/World/GUI").add_child(dialogBox)
		talkTimer.start()
		
	# skeleton examine
	if (player.interactable == true && Input.is_action_pressed("examine") && talkTimer.is_stopped()):
		collision.disabled = true
		var dialogBox = DialogBox.instance()
		dialogBox.dialog = [
			"A friendly looking skeleton.",
			"Actually, you can't tell the difference between rude and friendly skeletons, so you can't be sure."
		]
		get_node("/root/World/GUI").add_child(dialogBox)
		talkTimer.start()

func _on_Area2D_area_entered(area):
	player.interactable = true

func _on_Area2D_area_exited(area):
	player.interactable = false
	
func _on_Timer_timeout():
	collision.disabled = false
