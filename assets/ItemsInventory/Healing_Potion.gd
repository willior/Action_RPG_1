extends Node2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")

var interactable = true
var talkable = false
var examined = false
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = [
		{'text': "A Potion of Healing."},
		{'text': "Or Healing Potion, for short."}
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true
	
func interact():
	GameManager.player.state = 8
	var timer = Timer.new()
	timer.wait_time = 0.3
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	GameManager.player.inventory.add_item("Potion", 1)
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	itemCollectEffect.playSound(0)
	queue_free()
