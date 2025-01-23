extends Area2D
class_name UpgradeNode


@export var built_sprite : Texture2D
@export var raw_sprite : Texture2D

var claimed : bool = false
var level : int = 0

func _ready():
	%UpgradeButton.set_visible(false)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	
	var upgrade_type = UpgradeManager.Type.SHOT_NUMBER
	
	%UpgradeButton.button_up.connect(
			func(): SignalBus.upgrade_button_pressed.emit(self, upgrade_type)
		)


func claim_upgrade():
	%ResourceSprite.texture = built_sprite
	claimed = true
	#%UpgradeButton.set_visible(false)	
	SignalBus.upgrade_node_claimed.emit(self)
	
	level += 1
	%UpgradeLevelLabel.set_visible(true)
	%UpgradeLevelLabel.text = "Level " + str(level)


# To detect bullets?
func _on_area_entered(area):
	print_debug(area)


# To detect player and enemies?
func _on_body_entered(body):
	if body is Player: #and not claimed:
		%UpgradeButton.set_visible(true)	
	
	
func _on_body_exited(body):
	if body is Player: #and not claimed:
		%UpgradeButton.set_visible(false)
