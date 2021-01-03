extends Node

var dialog_script = [
	{
		'question': 'Yes or no?',
		'options': [
			{ 'label': 'Yes!', 'skip': '1' },
			{ 'label': 'No!', 'skip': '2' }
		]
			
	}
]

var empty_dictionary = {}

func _ready():
	for g in Global.custom_variables:
		print('hi')
		if Global.custom_variables.has(g):
			print(g)
