extends Node

onready var MessagePopup = preload("res://assets/UI/Popups/MessagePopup.tscn")
onready var Regen = preload("res://assets/Status/Buffs/Regen.tscn")
onready var Poison = preload("res://assets/Status/Debuffs/Poison.tscn")
onready var Frenzy = preload("res://assets/Status/Buffs/Frenzy.tscn")
onready var Stun = preload("res://assets/Status/Debuffs/Stun.tscn")

func apply_status(status, body):
	var status_display = body.get_node("StatusDisplay")
	match status[0]:
		"Regen":
			if status_display.has_node("Poison"):
				status_display.get_node("Poison").queue_free()
			if status_display.has_node("Regen"):
				status_display.get_node("Regen").refresh_status(status[2], status[3])
				return
			else:
				var regen = Regen.instance()
				regen.duration = status[2]
				regen.potency = status[3]
				status_display.add_child(regen)
		"Poison":
			if status_display.has_node("Poison"):
				return
			else:
				randomize()
				var status_check = randf()
				if status_check <= status[1] - body.stats.status_resistance:
					if status_display.has_node("Regen"):
						status_display.get_node("Regen").queue_free()
					# print('RNG ', status_check*100, '% was less than ', (status[1]-body.stats.status_resistance)*100, '% (status_chance - status_resistance)')
					var poison = Poison.instance()
					status_display.add_child(poison)
				else:
					# print('poison check unsuccessful; RNG ', status_check*100, '% was greater than ', (status[1]-body.stats.status_resistance)*100, '% (status_chance - status_resistance)')
					return
		"Frenzy":
			if status_display.has_node("Frenzy"):
				status_display.get_node("Frenzy").refresh_status(status[2], status[3])
				return
			else:
				var frenzy = Frenzy.instance()
				frenzy.duration = status[2]
				frenzy.potency = status[3]
				status_display.add_child(frenzy)
		"Stun":
			if status_display.has_node("Stun"):
				return
			else:
				randomize()
				var status_check = randf()
				if status_check <= status[1] - body.stats.status_resistance:
					var stun = Stun.instance()
					status_display.add_child(stun)
		"Slow":
			pass
		"Ablaze":
			pass

func remove_buffs(body):
	var status_display = body.get_node("StatusDisplay")
	for b in status_display.get_children():
		if "buff" in status_display.get_node(b.name):
			b.queue_free()

func remove_debuffs(body):
	var status_display = body.get_node("StatusDisplay")
	for d in status_display.get_children():
		if "debuff" in status_display.get_node(d.name):
			d.queue_free()
