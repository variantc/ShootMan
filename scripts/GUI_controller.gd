extends Node


func _ready():
	%ShotButton.button_up.connect(_on_shot_button_up)
	%SpreadButton.button_up.connect(_on_spread_button_up)


func _on_shot_button_up():
	SignalBus.button_shot_number_up.emit()


func _on_spread_button_up():
	SignalBus.button_shot_spread_up.emit()
