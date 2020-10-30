extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")

var interactable = true
var talkable = false
var examined = false

func _ready():
	if PlayerLog.metal_pot_collected:
		queue_free()
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"A metal pot."
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true
	
func interact():
	GameManager.player.inventory.add_item("Metal_Pot", 1)
	PlayerLog.metal_pot_collected = true
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	itemCollectEffect.playSound(1)
	queue_free()
