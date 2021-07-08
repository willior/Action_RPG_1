extends Node

onready var Regen = preload("res://assets/Status/Buffs/Regen.tscn")
onready var Poison = preload("res://assets/Status/Debuffs/Poison.tscn")
onready var Frenzy = preload("res://assets/Status/Buffs/Frenzy.tscn")
onready var Stun = preload("res://assets/Status/Debuffs/Stun.tscn")
onready var Haste = preload("res://assets/Status/Buffs/Haste.tscn")
onready var Slow = preload("res://assets/Status/Debuffs/Slow.tscn")

# status is an array with 4 indexes:
# 0. name (String)
# 1. chance (Float)
# 2. duration
# 3. potency

func apply_status(status, body):
	var status_display = body.get_node("StatusDisplay")
	match status[0]:
		"Cleanse":
			remove_last_debuff(body, status[2])
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
					resist_status(body, status[0])
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
				else:
					resist_status(body, status[0])
		"Haste":
			if status_display.has_node("Slow"):
				status_display.get_node("Slow").queue_free()
			if status_display.has_node("Haste"):
				pass
				# status_display.get_node("Haste").refresh_status(status[2], status[3])
			else:
				var haste = Haste.instance()
#				haste.duration = status[2]
#				haste.potency = status[3]
				status_display.add_child(haste)
				
		"Slow":
			if status_display.has_node("Slow"):
				return
			else:
				randomize()
				var status_check = randf()
				if status_check <= status[1] - body.stats.status_resistance:
					if status_display.has_node("Haste"):
						status_display.get_node("Haste").queue_free()
					var slow = Slow.instance()
					status_display.add_child(slow)
				else:
					resist_status(body, status[0])
					#body.hurtbox.display_damage_popup("Resisted!", false, status[0])
		"Ablaze":
			pass

func resist_status(body, status_name:String):
	body.hurtbox.display_damage_popup(str(status_name + " Resisted!"), false, status_name, 0)

func remove_buffs(body):
	var status_display = body.get_node("StatusDisplay")
	for b in status_display.get_children():
		if "buff" in status_display.get_node(b.name):
			b.queue_free()

func remove_last_debuff(body, cleanse_level:int):
	var status_display = body.get_node("StatusDisplay")
	var debuffs_to_cleanse = cleanse_level
	for d in range(status_display.get_child_count()-1, -1, -1):
		if "debuff" in status_display.get_child(d):
			if status_display.get_child(d).name == "Stun":
				print("can't cleanse Stun; continuing")
				continue
			body.hurtbox.display_damage_popup(str(status_display.get_child(d).name+" Cleansed!"), false, str(status_display.get_child(d).name), 1)
			status_display.get_child(d).queue_free()
			debuffs_to_cleanse -= 1
			if debuffs_to_cleanse > 0:
				continue
			else:
				return

func remove_debuffs(body):
	var status_display = body.get_node("StatusDisplay")
	for d in status_display.get_children():
		if "debuff" in status_display.get_node(d.name):
			d.queue_free()
