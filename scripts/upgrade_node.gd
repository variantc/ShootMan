extends Area2D
class_name UpgradeNode


func _ready():
	%UpgradeButton.set_visible(false)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	var upgrade_type = UpgradeManager.Type.SHOT_NUMBER
	
	%UpgradeButton.button_up.connect(
			func(): SignalBus.upgrade_button_pressed.emit(upgrade_type)
		)


# To detect bullets?
func _on_area_entered(area):
	print_debug(area)


# To detect player and enemies?
func _on_body_entered(body):
	if body is Player:
		%UpgradeButton.set_visible(true)	
	
	
func _on_body_exited(body):
	if body is Player:
		%UpgradeButton.set_visible(false)
