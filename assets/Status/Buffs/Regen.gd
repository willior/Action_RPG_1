extends Node2D

# const MessagePopup = preload("res://assets/UI/Popups/MessagePopup.tscn")
const Icon = preload("res://assets/UI/Status/Buffs/RegenIcon.tscn")
export var duration = 16 # number of ticks
export var potency = 1 # damage per tick
onready var body = get_parent().get_parent()
signal regen_removed()

func _ready():
	body.hurtbox.display_damage_popup("Regen", false, "Heal")
	# var messagePopup = MessagePopup.instance()
	if body.get("ENEMY_NAME"):
		pass
		# messagePopup.message = str(body.ENEMY_NAME, ' is regened!')
	else:
		# messagePopup.message = "Regened!"
		var icon = Icon.instance()
		icon.duration = duration
		get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs").add_child(icon)
	# get_node("/root/World/GUI/MessageDisplay1/MessageContainer").add_child(messagePopup)
	$Timer.start(duration)
	$AnimatedSprite.play()

func refresh_status():
	body.hurtbox.display_damage_popup("Regen", false, "Heal")
	# var messagePopup = MessagePopup.instance()
	if body.get("ENEMY_NAME"):
		pass
		# messagePopup.message = str(body.ENEMY_NAME, ' is regened!')
	else:
		# messagePopup.message = "Regened!"
		get_node("/root/World/GUI/StatusDisplay1/StatusContainer/Buffs/RegenIcon").refresh_status_icon()
	# get_node("/root/World/GUI/MessageDisplay1/MessageContainer").add_child(messagePopup)
	$Timer.start(duration)

func _on_RegenIndicator_animation_finished():
	body.stats.health += potency
	if body.get("enemyHealth"):
		body.enemyHealth.show_health()
	body.hurtbox.display_damage_popup(str(potency), false, "Heal")

func _on_Timer_timeout():
	queue_free()

func _on_RegenIndicator_tree_exiting():
	emit_signal("regen_removed")
