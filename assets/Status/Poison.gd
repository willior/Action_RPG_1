extends Node2D

const MessagePopup = preload("res://assets/UI/Popups/MessagePopup.tscn")
const PoisonIcon = preload("res://assets/UI/Status/PoisonIcon.tscn")

export var count = 0
export var duration = 16 # number of ticks
export var potency = 1 # damage per tick

onready var body = get_parent()

signal poison_progress_updated(value)

func _ready():
	print(body.name, ' is poisoned!')
	body.hurtbox.display_damage_popup("Poisoned!", false, "Poison")
	var messagePopup = MessagePopup.instance()
	if body.get("ENEMY_NAME"):
		messagePopup.message = str(body.ENEMY_NAME, ' is poisoned!')
	else:
		messagePopup.message = "Poisoned!"
		var poison_icon = PoisonIcon.instance()
		poison_icon.max_value = duration
		get_node("/root/World/GUI/StatusDisplay1/StatusContainer").add_child(poison_icon)
	get_node("/root/World/GUI/MessageDisplay1/MessageContainer").add_child(messagePopup)
	messagePopup.poison_flash()
	activate()

func activate():
	if !$PoisonNotice.playing:
		$PoisonNotice.play()
		count = 1
	else:
		count = 0

func _on_PoisonNotice_animation_finished():
	poison_tick()
	if count == duration:
		queue_free()
	else:
		$PoisonNotice.flip_h = false if $PoisonNotice.flip_h else true
		count += 1

func poison_tick():
	if body.stats.health <= 0:
		queue_free()
	else:
		body.stats.health -= potency
		if body.get("enemyHealth"):
			body.enemyHealth.show_health()
		body.hurtbox.display_damage_popup(str(potency), false, "Poison")
		emit_signal("poison_progress_updated", count)
