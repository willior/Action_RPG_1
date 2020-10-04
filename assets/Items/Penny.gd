extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")

onready var player = get_node("/root/World/YSort/Player")

var interactable = false
var talkable = false
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"A copper coin.",
		"You wouldn't normally pick these up."
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	player.talkTimer.start()

func _on_PennyCollectBox_area_entered(_area):
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	itemCollectEffect.playSound(1)
	
	PlayerStats.cash += 0.01
	queue_free()
