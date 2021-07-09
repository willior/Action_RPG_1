extends "res://assets/Player/Stats/FormulaData.gd"

func save():
	var player2_formulaData = {
		"Heal": Heal,
		"Cleanse": Cleanse,
		"Hardball": Hardball,
		"Flash": Flash,
		"Quicken": Quicken,
		"Fury": Fury
	}
	var save_dict = {
		"player2_formulaData": player2_formulaData
	}
	return save_dict
