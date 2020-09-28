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
			"A heart-shaped box. It's full of chocolate!",
			"Actually, there's only one left."
		]
		get_node("/root/World/GUI").add_child(dialogBox)
		player.talkTimer.start()

func _on_HeartTalkBox_area_entered(area):
	# $AudioCursHi.play()
	player.interacting = true
	interactable = true

func _on_HeartTalkBox_area_exited(area):
	player.interacting = false
	interactable = false

func _on_HeartCollectBox_area_entered(area):
	$Sprite.queue_free()
	$HeartTalkBox.queue_free()
	$HeartCollectBox.queue_free()
	
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	itemCollectEffect.playSound(0)
	
	PlayerStats.health += 1
	queue_free()
