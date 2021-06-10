extends CanvasLayer

func _ready():
	toggle_multiplayer_gui()

func hide_UI_elements():
	$HealthUI1.hide()
	$StaminaBar1.hide()
	$ExpBar1.hide()
	$FormulaUI1.hide()
	$MessageDisplay1.hide()
	$StatusDisplay1.hide()
	if GameManager.multiplayer_2:
		$HealthUI2.hide()
		$StaminaBar2.hide()
		$ExpBar2.hide()
		$FormulaUI2.hide()
		$MessageDisplay2.hide()
		$StatusDisplay2.hide()

func show_UI_elements():
	$HealthUI1.show()
	$StaminaBar1.show()
	$ExpBar1.show()
	$FormulaUI1.show()
	$MessageDisplay1.show()
	$StatusDisplay1.show()
	if GameManager.multiplayer_2:
		$HealthUI2.show()
		$StaminaBar2.show()
		$ExpBar2.show()
		$FormulaUI2.show()
		$MessageDisplay2.show()
		$StatusDisplay2.show()

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
