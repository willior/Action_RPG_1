extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")

var interactable = false
var talkable = false
var examined = false
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"A copper coin.",
		"You wouldn't normally pick these up."
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true

func _on_PennyCollectBox_area_entered(_area):
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	itemCollectEffect.playSound(1)
	PlayerStats.cash += 0.01
	queue_free()
