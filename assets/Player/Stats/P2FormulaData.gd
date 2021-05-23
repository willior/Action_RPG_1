extends "res://assets/Player/Stats/FormulaData.gd"

func save():
	var player2_formulaData = {
		"Flash": Flash,
		"Heal": Heal,
		"Fury": Fury
	}
	var save_dict = {
		"player2_formulaData": player2_formulaData
	}
	return save_dict
