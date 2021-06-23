extends Control

onready var text = $Label
onready var tween = $Tween
var message : String
var flash : String
var fade = Color(1, 1, 1, 0)

func _ready():
	text.set_text(message)
	match flash:
		"crit":
			crit_flash()
		"pickup":
			pickup_flash()
		"level":
			level_flash()
		"poison":
			poison_flash()

func crit_flash():
	$AnimationPlayer.play("crit_flash")
	fade = Color(1, 0, 0, 0)

func pickup_flash():
	$AnimationPlayer.play("pickup_flash")

func level_flash():
	$AnimationPlayer.play('level_flash')

func poison_flash():
	$AnimationPlayer.play('poison_flash')
	fade = Color(0.5, 0, 1, 0)

func _on_AnimationPlayer_animation_finished(_anim_name):
	tween.interpolate_property(
	text,
	"modulate",
	Color(1,1,1,1),
	fade,
	2.4,
	Tween.TRANS_QUINT,
	Tween.EASE_IN
	)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
