extends Node2D

onready var pos = global_position
onready var player = get_node("/root/World/Player")
onready var playerParent = get_node("/root/World/YSort")

func _ready():
	# var player = PLAYER.instance()
	# get_parent().call_deferred("add_child", Player)
	
	reparent(player, playerParent)
	player.global_position = pos
	
	queue_free()

func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.call_deferred("remove_child", child)
	new_parent.call_deferred("add_child", child)
	print(child)
