extends CanvasLayer

func _ready():
	toggle_multiplayer_gui()

func toggle_multiplayer_gui():
	if GameManager.multiplayer_2:
		$HealthUI2.show()
		$StaminaBar2.show()
		$ExpBar2.show()
		$FormulaUI2.show()
		$MessageDisplay2.show()
		$StatusDisplay2.show()
	else:
		$HealthUI2.hide()
		$StaminaBar2.hide()
		$ExpBar2.hide()
		$FormulaUI2.hide()
		$MessageDisplay2.hide()
		$StatusDisplay2.hide()
