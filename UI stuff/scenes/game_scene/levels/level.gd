extends Node

signal level_won
signal level_lost
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var timer: Timer = $BombTimer
@onready var time_label: Label = $TimeLabel
var max_time := 10.0  # in seconds
@onready var array: Array[Variant] = [preload("res://assets/SFX/explosion-42132.mp3"),
									 preload("res://assets/SFX/explosion-91004.mp3"),
									 preload("res://assets/SFX/explosion-fx-343683.mp3")]
@onready var audio := AudioStreamPlayer2D.new():
	set(val):
		audio = val
		self.add_child(val)

var level_state : LevelState

func _on_lose_button_pressed() -> void:
	level_lost.emit()
	audio.play(0.0)
	audio.stream = array.pick_random()
	print(self)
	

func _on_win_button_pressed() -> void:
	level_won.emit()

func open_tutorials() -> void:
	%TutorialManager.open_tutorials()
	level_state.tutorial_read = true

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	%ColorPickerButton.color = level_state.color
	%BackgroundColor.color = level_state.color
	if not level_state.tutorial_read:
		open_tutorials()
	# Set Timer properties
	timer.wait_time = max_time
	timer.one_shot = true
	timer.start()

	# Set ProgressBar range
	progress_bar.min_value = 0
	progress_bar.max_value = max_time
	progress_bar.value = max_time

	# Update bar every frame
	set_process(true)

func _on_color_picker_button_color_changed(color : Color) -> void:
	%BackgroundColor.color = color
	level_state.color = color
	GlobalState.save()

func _on_tutorial_button_pressed() -> void:
	open_tutorials()
	
func _on_bomb_timer_timeout() -> void:
	level_lost.emit()

func _process(_delta):
	if timer.time_left > 0:
		progress_bar.value = timer.time_left
		time_label.text = "%.1fs" % timer.time_left  # shows 1 decimal place like "9.2s"
		if timer.time_left <= 3.0:
			time_label.modulate = Color.RED
		else:
			time_label.modulate = Color.WHITE
	else:
		progress_bar.value = 0
