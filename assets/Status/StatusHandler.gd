extends Node

onready var MessagePopup = preload("res://assets/UI/Popups/MessagePopup.tscn")
onready var Regen = preload("res://assets/Status/Buffs/Regen.tscn")
onready var Poison = preload("res://assets/Status/Debuffs/Poison.tscn")
onready var Stun = preload("res://assets/Status/Debuffs/Stun.tscn")

func apply_status(status, body):
	match status[0]:
		"Regen":
			if body.has_node("Regen"):
				print(body, ' is already regened; refreshing')
				body.get_node("Regen").refresh_status()
				return
			else:
				var regen = Regen.instance()
				body.add_child(regen)
		"Poison":
			if body.has_node("Poison"):
				return
			else:
				randomize()
				var status_check = randf()
				if status_check <= status[1] - body.stats.status_resistance:
					# print('RNG ', status_check*100, '% was less than ', (status[1]-body.stats.status_resistance)*100, '% (status_chance - status_resistance)')
					var poison = Poison.instance()
					body.add_child(poison)
				else:
					# print('poison check unsuccessful; RNG ', status_check*100, '% was greater than ', (status[1]-body.stats.status_resistance)*100, '% (status_chance - status_resistance)')
					return
		
		"Stun":
			if body.has_node("Stun"):
				print(body, ' is already stunned; returning')
				return
			else:
				randomize()
				var status_check = randf()
				if status_check <= status[1] - body.stats.status_resistance:
					var stun = Stun.instance()
					body.add_child(stun)
		"Slow":
			pass
		"Ablaze":
			pass
