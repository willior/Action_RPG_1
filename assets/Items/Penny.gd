extends Node2D

const DialogBox = preload("res://assets/UI/Dialog.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")

onready var player = get_parent().get_node("Player")

var interactable = false

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if (interactable && Input.is_action_pressed("examine") && player.talkTimer.is_stopped()):
		# talkBox.disabled = true
		var dialogBox = DialogBox.instance()
		dialogBox.dialog = [
			"A copper coin.",
			"You wouldn't normally pick these up."
		]
		get_node("/root/World/GUI").add_child(dialogBox)
		player.talkTimer.start()

func _on_PennyTalkBox_area_entered(area):
	# $AudioCursHi.play()
	player.interacting = true
	interactable = true

func _on_PennyTalkBox_area_exited(area):
	player.interacting = false
	interactable = false

func _on_PennyCollectBox_area_entered(area):
	$Sprite.queue_free()
	$PennyTalkBox.queue_free()
	$PennyCollectBox.queue_free()
	
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	itemCollectEffect.playSound(1)

	PlayerStats.cash += 0.01
	queue_free()