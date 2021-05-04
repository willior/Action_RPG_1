extends Control

onready var text = $Label
onready var tween = $Tween
var message : String
var fade = Color(1, 1, 1, 0)

func _ready():
	text.set_text(message)

func crit_flash():
	$AnimationPlayer.play("crit")
	fade = Color(1, 0, 0, 0)
	
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
	3.2,
	Tween.TRANS_QUINT,
	Tween.EASE_IN
	)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
