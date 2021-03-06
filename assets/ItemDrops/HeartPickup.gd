extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")

var interactable = false
var talkable = false
var examined = false
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"A heart-shaped box. It's full of chocolate!",
		"Actually, there's only one left."
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true

func _on_HeartCollectBox_area_entered(_area):
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	# argument determines sound effect; 0 = heartCollect
	itemCollectEffect.playSound(0)
	Player1Stats.health += 1
	queue_free()
