extends Control

signal level_won
signal level_lost

var input_string := ""

func _ready():
	for button in get_children():
		if button is Button:
			button.pressed.connect(_on_button_pressed_)

func _on_button_pressed(text):
	match text:
		"Clear":
			input_string = ""
		"Enter":
			_check_input()
		_:
			input_string += text
	print("Current input: ", input_string)

func _check_input():
	if input_string == "1234": # <- replace with your solution
		print("Correct code!")
		level_won.emit()
		# Trigger success (e.g. open door, advance level)
	else:
		print("Incorrect.")
		level_lost.emit()
	input_string = "" # Reset after checking
