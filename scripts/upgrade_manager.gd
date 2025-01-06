extends Node


@export var score_text : ScoreText


func _ready():
	SignalBus.button_shot_number_up.connect(_on_button_shot_number)
	SignalBus.button_shot_spread_up.connect(_on_button_spread)

	
func _on_button_shot_number():
	if score_text.score >= 2:
		score_text.score -= 2
		SignalBus.change_shot_number.emit(1)


func _on_button_spread():
	if score_text.score >= 2:
		score_text.score -= 2
		SignalBus.change_shot_spread.emit(10)
