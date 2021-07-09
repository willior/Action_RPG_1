extends "res://assets/Player/Stats/FormulaData.gd"

func save():
	var player1_formulaData = {
		"Heal": Heal,
		"Cleanse": Cleanse,
		"Hardball": Hardball,
		"Flash": Flash,
		"Quicken": Quicken,
		"Fury": Fury
	}
	var save_dict = {
		"player1_formulaData": player1_formulaData
	}
	return save_dict
