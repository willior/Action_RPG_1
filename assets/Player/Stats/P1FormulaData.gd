extends "res://assets/Player/Stats/FormulaData.gd"

func save():
	var player1_formulaData = {
		"Flash": Flash,
		"Heal": Heal,
		"Fury": Fury
	}
	var save_dict = {
		"player1_formulaData": player1_formulaData
	}
	return save_dict
