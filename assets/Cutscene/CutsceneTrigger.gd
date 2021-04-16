extends Node2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const InnerDialogBox = preload("res://assets/UI/Dialog/InnerDialogBox.tscn")

var interactable = true
var talkable = false
var examined = false
var count

onready var player = get_tree().get_root().get_node("/root/World/YSort/Player")

func examine():
	var dialog = DialogBox.instance()
	dialog.dialog_script = [
		{
			'text': 'An ordinary pot of water, or so it seems.'
		}
	]
	get_node("/root/World/GUI").add_child(dialog)
	
func interact():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for i in enemies:
		var dialog = DialogBox.instance()
		dialog.dialog_script = [
			{
				'text': 'Might want to take care of that there enemy first, buddy boy.'
			}
		]
		get_node("/root/World/GUI").add_child(dialog)
		return
# warning-ignore:unreachable_code
	count = 0
	$Timer.wait_time = 1.2
	$AnimationPlayer.play("Cutscene")
	Global.in_cutscene = true

func cutscene1():
	player.state = 8
	player.animationTree.active = false
	player.animationPlayer.play("PickupCutscene")

func cutscene2():
	var dialog = DialogBox.instance()
	dialog.dialog_script = [
		{
			'text': 'Oh look. Something is here.'
		}
	]
	get_node("/root/World/GUI").add_child(dialog)
	
func cutscene3():
	var dialog = InnerDialogBox.instance()
	dialog.dialog_script = [
		{
			'text': 'Can you hear me?'
		},
		{
			'text': 'That is no ordinary pot of water...'
		}
	]
	dialog.rect_position.y -= 60
	get_node("/root/World/GUI").add_child(dialog)
	
func cutscene4():
	$Music.stop()
	$CanvasLayer/White.flash()

func cutscene_end():
	var dialog = DialogBox.instance()
	dialog.dialog_script = [
		{
			'text': 'Well!'
		}
	]
	get_node("/root/World/GUI").add_child(dialog)
	Global.in_cutscene = false
	
func play_music():
	$Music.play()
	$Tween.interpolate_property($Music, "volume_db",
		-32, 0, 2,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT
		)
		
func drain_hp():
	if count > 18:
		return
	$Timer.start()
	yield($Timer, "timeout")
	PlayerStats.health -= 1
	$Timer.wait_time = $Timer.wait_time - 0.06
	count += 1
	drain_hp()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Cutscene":
		get_tree().get_root().get_node("/root/World/YSort/Player").state = 0
		player.animationTree.active = true
