extends Node2D

var lightswitch_examined_while_on = false
var lightswitch_examined_while_off = false

func _ready():
	if PlayerLog.chapter_number == 0:
		pass
#		Global.chapter_display = true
#		Global.chapter_name = "CHAPTER ONE"
#		PlayerLog.chapter_number = 1
	else:
		get_node("/root/World/SFX").volume_db = 0 
