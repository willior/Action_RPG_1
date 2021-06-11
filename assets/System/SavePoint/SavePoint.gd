extends Node2D

const SaveText = preload("res://assets/System/SavePoint/SaveText.tscn")

func _on_Area2D_body_entered(_body):
	var saveText = SaveText.instance()
	get_node("/root/World/GUI").add_child(saveText)
	GameManager.save_game()
	$AudioStreamPlayer.play()
	$Timer.start(.9)
	get_tree().paused = true
	yield($Timer, "timeout")
	get_tree().paused = false
	Player1Stats.recovery()
	StatusHandler.remove_debuffs(GameManager.player)
	if GameManager.multiplayer_2:
		Player2Stats.recovery()
		StatusHandler.remove_debuffs(GameManager.player2)
