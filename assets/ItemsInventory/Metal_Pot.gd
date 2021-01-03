extends Node2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")

var interactable = true
var talkable = false
var examined = false
var answer

func _ready():
	if PlayerLog.metal_pot_collected:
		queue_free()
	
func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = [
		{
			'text': "A metal pot, for cooking."
		}
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true
	
func interact():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_object_path = get_path()
	print(get_path())
	dialogBox.dialog_script = [
		{ # 0
			'question': 'Take the Metal Pot?',
			'options': [
				{ 'label': 'Yes', 'skip': '0'},
				{ 'label': 'No', 'skip': '1'},
				{ 'label': 'Touch it first', 'skip': '2'}
			],
			'variable': 'answer'
		},
		{ # 1
			'text': 'Yes.'
		},
		{ # 2
			'text': 'No'
		},
		{ # 3
			'text': 'Touch.'
		},
		{ # 4
			'action': 'take_item'
		}
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	
	prints("metal pot: " + str(Global.custom_variables))
	
func acquire_item():
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	itemCollectEffect.playSound(1)
	GameManager.player.inventory.add_item("Metal_Pot", 1)
	PlayerLog.metal_pot_collected = true
	queue_free()
