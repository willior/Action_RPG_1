extends Node

export var duration = 3 # duration in seconds
export var potency = 2 # attack speed multiplier

var old_attack_speed
var new_attack_speed
var active = false

func activate():
	if !active:
		active = true
		old_attack_speed = PlayerStats.attack_speed
		new_attack_speed = PlayerStats.attack_speed * potency
		PlayerStats.attack_speed = new_attack_speed
		$Timer.start(duration)

func _on_Timer_timeout():
	active = false
	PlayerStats.attack_speed = old_attack_speed
	PlayerStats.status = "frenzy_end"
