extends "res://assets/Player/Stats/PlayerStats.gd"

func save():
	var player2_stats = {
		"vitality": vitality,
		"health": health,
		"max_health": max_health,
		"endurance": endurance,
		"stamina": stamina,
		"max_stamina": max_stamina,
		"defense": defense,
		"strength": strength,
		"dexterity": dexterity,
		"speed": speed,
		"magic": magic,
		"level": level,
		"experience": experience,
		"experience_required": experience_required,
		"experience_total": experience_total
	}
	var save_dict = {
		"player2_stats": player2_stats
	}
	return save_dict
