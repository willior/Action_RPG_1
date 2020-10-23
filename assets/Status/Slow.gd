extends Node2D

var count = 0
var duration = 3

func _ready():
	print('instantiating poison')

func _on_Timer_timeout():
	PlayerStats.health -= 1
	count += 1
	if count == duration:
		print('deleting poison')
		queue_free()
