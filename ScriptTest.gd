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

func _ready():
	print(dialog_script)
