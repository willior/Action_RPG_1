extends Node2D

# const MessagePopup = preload("res://assets/UI/Popups/MessagePopup.tscn")
const Icon = preload("res://assets/UI/Status/Debuffs/PoisonIcon.tscn")
export var count = 0
export var duration = 16 # number of ticks
export var potency = 1 # damage per tick
onready var body = get_parent()
signal poison_removed()

func _ready():
	print(body.name, ' is poisoned!')
	body.hurtbox.display_damage_popup("Poisoned!", false, "Poison")
	# var messagePopup = MessagePopup.instance()
	if body.get("ENEMY_NAME"):
		pass
		# messagePopup.message = str(body.ENEMY_NAME, ' is poisoned!')
	else:
		# messagePopup.message = "Poisoned!"
		var icon = Icon.instance()
		icon.duration = duration
		get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Debuffs").add_child(icon)
	# get_node("/root/World/GUI/MessageDisplay1/MessageContainer").add_child(messagePopup)
	# messagePopup.poison_flash()
	$Timer.start(duration)
	$PoisonIndicator.play()

func _on_PoisonIndicator_animation_finished():
	if body.stats.health <= 0:
		print('poison tick at 0 health: deleting poison')
		queue_free()
	else:
		body.stats.health -= potency
		if body.get("enemyHealth"):
			body.enemyHealth.show_health()
		body.hurtbox.display_damage_popup(str(potency), false, "Poison")

func _on_Timer_timeout():
	print('poison timer timeout')
	queue_free()

func _on_PoisonNotice_tree_exiting():
	print('poison exiting tree')
	emit_signal("poison_removed")
