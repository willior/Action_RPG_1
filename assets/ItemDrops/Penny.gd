extends Node2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")

var interactable = false
var talkable = false
var examined = false
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = [
		{'text': "A copper coin."},
		{'text': "You wouldn't normally pick these up."}
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true

func _on_PennyCollectBox_area_entered(_area):
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	itemCollectEffect.playSound(1)
	Player1Stats.cash += 0.01
	queue_free()
