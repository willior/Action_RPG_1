extends Node2D

const SaveText = preload("res://assets/System/SavePoint/SaveText.tscn")

func _on_Area2D_body_entered(_body):
	var saveText = SaveText.instance()
	get_node("/root/World/GUI").add_child(saveText)
	$AudioStreamPlayer.play()
	Player1Stats.recovery()
	StatusHandler.remove_debuffs(GameManager.player)
	if GameManager.multiplayer_2:
		Player2Stats.recovery()
		StatusHandler.remove_debuffs(GameManager.player2)
	$Timer.start(.9)
	get_tree().paused = true
	yield($Timer, "timeout")
	GameManager.save_game()
	if Global.target_screen_open:
		return
	get_tree().paused = false
	
