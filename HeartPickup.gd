extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")

onready var player = get_node("/root/World/YSort/Player")

var interactable = false
var talkable = false
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"A heart-shaped box. It's full of chocolate!",
		"Actually, there's only one left."
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	player.talkTimer.start()

func _on_HeartTalkBox_area_entered(_area):
	player.interacting = true
	interactable = true

func _on_HeartTalkBox_area_exited(_area):
	player.interacting = false
	interactable = false

func _on_HeartCollectBox_area_entered(_area):
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	# argument determines sound effect; 0 = heartCollect
	itemCollectEffect.playSound(0)
	
	PlayerStats.health += 1
	queue_free()

