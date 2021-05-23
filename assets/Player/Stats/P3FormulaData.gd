extends "res://assets/Player/Stats/FormulaData.gd"

func save():
	var player3_formulaData = {
		"Flash": Flash,
		"Heal": Heal,
		"Fury": Fury
	}
	var save_dict = {
		"player3_formulaData": player3_formulaData
	}
	return save_dict
