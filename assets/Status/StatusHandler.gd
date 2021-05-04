extends Node

onready var Poison = preload("res://assets/Status/Poison.tscn")

func apply_status(status, body):
	match status:
		"Poison":
			var poison = Poison.instance()
			body.add_child(poison)
