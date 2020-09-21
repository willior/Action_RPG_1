extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")

onready var player = get_parent().get_node("Player")
onready var timer = $Timer
onready var collision = $KinematicBody2D/Area2D/CollisionShape2D

func _process(delta):
	if (player.interactable == true && Input.is_action_pressed("attack") && timer.is_stopped()):
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
		timer.start()


func _on_Area2D_area_entered(area):
	print("area entered")
	player.interactable = true

func _on_Area2D_area_exited(area):
	player.interactable = false
	
func _on_Timer_timeout():
	collision.disabled = false
	print('timeout')
