extends Node2D

var lightswitch_examined_while_on = false
var lightswitch_examined_while_off = false

func _ready():
	if PlayerLog.chapter_number == 0:
		return
# warning-ignore:unreachable_code
		get_node("/root/World/SFX").volume_db = -27
		Global.chapter_display = true
		Global.chapter_name = "CHAPTER ONE"
		PlayerLog.chapter_number = 1
