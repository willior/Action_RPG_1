extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")

var interactable = true
var talkable = false
var examined = false
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"A Potion of Healing.",
		"Or Healing Potion, for short."
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true
	
func interact():
	print("interacting with healing potion")
	GameManager.player.inventory.add_item("Potion", 1)
	queue_free()
