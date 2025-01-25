extends Area2D
class_name UpgradeNode


@export var built_sprite : Texture2D
@export var raw_sprite : Texture2D

@export var upgrade_button : Button
@export var health_bar : ProgressBar

var claimed : bool = false
var level : int = 0

func _ready():
	upgrade_button.set_visible(false)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	
	var upgrade_type = UpgradeManager.Type.SHOT_NUMBER
	
	upgrade_button.button_up.connect(
			func(): SignalBus.upgrade_button_pressed.emit(self, upgrade_type)
		)


# pass flag = false to unclaim
func claim_upgrade(unclaim=false):
	var sprite = built_sprite
	if unclaim:
		sprite = raw_sprite
		
	%ResourceSprite.texture = sprite
	claimed = not unclaim
	
	SignalBus.upgrade_node_claimed.emit(self)
	
	level += 1 if claimed else 0
	
	%UpgradeLevelLabel.set_visible(claimed)
	%UpgradeLevelLabel.text = "Level " + str(level)


# To detect bullets?
func _on_area_entered(area):
	print_debug(area.name + " area")


# To detect player and enemies?
func _on_body_entered(body):
	if body is Player: #and not claimed:
		upgrade_button.set_visible(true)	
	if body is EnemyStandard:
		print_debug(body.name + " body")
		claim_upgrade(unclaim=true)
	
	
func _on_body_exited(body):
	if body is Player: #and not claimed:
		upgrade_button.set_visible(false)
