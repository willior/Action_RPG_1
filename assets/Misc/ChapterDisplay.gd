extends Node
export(PackedScene) var SCENE_STRING
onready var sprite = $Sprite
onready var sfx = get_node("/root/World/SFX")
var index = 0

func _ready():
	$Chapter.visible = false
	$Chapter.text = Global.chapter_name
	get_tree().paused = true

func _on_Timer_timeout():
	print('timeout ', index)
	match index:
		0:
			$Chapter.visible = true
			$Timer.start(3.0)
			index += 1
		1:
			get_tree().paused = false
			$Tween.interpolate_property(sprite, "modulate",
			Color(1,0,0,1), Color(1,1,0,0), 3.5,
			Tween.TRANS_QUAD, Tween.EASE_IN
			)
			$Tween.interpolate_property(sfx, "volume_db",
			-27, 0, 5.5,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
			)
			$Tween.start()
			yield($Tween, "tween_completed")
			$Tween.interpolate_property($Chapter, "modulate",
			Color(1,1,1,1), Color(1,1,1,0), 2.0,
			Tween.TRANS_QUAD, Tween.EASE_OUT
			)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			print('done!')
			queue_free()

func _on_AudioStreamPlayer_finished():
	print('audio done')

func _on_Tween_tween_completed(object, key):
	print("object: ", object, " //// key: ", key)
