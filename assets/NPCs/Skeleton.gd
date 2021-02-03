extends Node2D

const DialogBox = preload("res://assets/UI/DialogBox.tscn")
var interactable = false
var talkable = true
var examined = false
var dialog_index = 0
var examine_index = 0
var answer
var speaker = "Skeleton"

func ready():
	$Sprite.frame = 1

func talk():
	var dialogBox = DialogBox.instance()
	match dialog_index:
#		0:
#			dialogBox.dialog_script = [
#				{'text': "Hello.",
#				'name': speaker},
#				{'text': "As you can see, I am a skeleton.",
#				'name': speaker},
#				{'text': "Unless, of course, you can't see.",
#				'name': speaker},
#				{'text': "In which case...",
#				'name': speaker},
#				{'text': "I'm still a skeleton.",
#				'name': speaker},
#				{'text': "Hahahahahahaha!!",
#				'name': speaker}
#			]
#			dialog_index += 1
#		1:
#			dialogBox.dialog_script = [
#				{'text': "Oh. You again.",
#				'name': speaker},
#				{'text': "Like you, I do not know why I exist.",
#				'name': speaker},
#				{'text': "...",
#				'name': speaker},
#				{'text': "I suppose that was a bit rude of me to assume.",
#				'name': speaker},
#				{'text': "Don't take it personally!",
#				'name': speaker},
#				{'text': "Hahahahahahaha!!",
#				'name': speaker}
#			]
#			dialog_index = 0
#			examine_index = 1

		0:
			dialogBox.dialog_object_path = get_path()
			dialogBox.dialog_script = [
				{
					'text': "Hello.",
					'name': speaker
				},
				{
					'name': speaker,
					'question': 'Yes or no?',
					'options': [
						{ 'label': 'Yes', 'skip': '0'},
						{ 'label': 'No', 'skip': '1'},
						{ 'label': 'Maybe', 'skip': '2'}
					],
					'variable': 'answer',
				},
				{
					'name': speaker,
					'text': 'Nice to have some blind positivity around here, for a change.',
					'skip': '2'
				},
				{
					'name': speaker,
					'text': "Oh, great. I was hoping you'd say that.",
					'skip': '1'
				},
				{
					'name': speaker,
					'text': "You didn't seem like the type to commit to anything, anyway.",
					'skip': '0'
				},
				{
					'name': speaker,
					'question': "Unless... you've changed your mind?",
					'options': [
						{ 'label': 'Uh...', 'value': '0'},
						{ 'label': 'Nope.', 'value': 'confirm'}
					],
					'checkpoint': '-5',
				},
				{
					'name': speaker,
					'text': 'Well, alright, then.'
				}
				
			]
			dialog_index += 1
		1:
			dialogBox.dialog_object_path = get_path()
			dialogBox.dialog_script = [
				{
					'text': "Hello, again.",
					'name': speaker
				},
				{
					'text': "Don't you have anything else to do with your time?",
					'name': speaker
				}
			]
			dialog_index += 1
			examine_index = 1
		2:
			dialogBox.dialog_object_path = get_path()
			dialogBox.dialog_script = [
				{
					'text': "...",
					'name': speaker
				}
			]
	get_node("/root/World/GUI").add_child(dialogBox)
	
func examine():
	var dialogBox = DialogBox.instance()
	print(dialogBox.dialog_script)
	match examine_index:
		0:
			dialogBox.dialog_script = [
				{
					'text': "A friendly looking skeleton.",
				},
				{
					'text': "Actually, you can't tell the difference between rude and friendly skeletons, so you can't be sure."
				}
			]
		1:
			dialogBox.dialog_script = [
				{
					'text': "A friendly looking skeleton.",
				},
				{
					'text': "But it turns out he's actually quite rude."
				}
			]

	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true
