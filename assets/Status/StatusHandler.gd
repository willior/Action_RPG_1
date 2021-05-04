extends Node

onready var MessagePopup = preload("res://assets/UI/Popups/MessagePopup.tscn")
onready var Poison = preload("res://assets/Status/Poison.tscn")

func apply_status(status, body):
	match status[0]:
		"Poison":
			if body.has_node("Poison"):
				print('poison already on ', body, '; returning.')
				return
			else:
				print('poison not on ', body, '; running check.')
				randomize()
				if randf() < status[1]:
					var poison = Poison.instance()
					body.add_child(poison)
					print('poison check success; applying.')
				else:
					print('poison check unsuccessful; returning.')
					return
