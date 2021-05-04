extends Node

onready var Poison = preload("res://assets/Status/Poison.tscn")

func apply_status(status, body):
	match status:
		"Poison":
			if body.has_node("Poison"):
				print('poison already on ', body, '; returning.')
				return
			else:
				print('poison not on ', body, '; instantiating.')
				var poison = Poison.instance()
				body.add_child(poison)
