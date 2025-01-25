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
	health_bar.set_visible(false)
	%UpgradeLevelLabel.set_visible(false)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	
	var upgrade_type = UpgradeManager.Type.SHOT_NUMBER
	
	upgrade_button.button_up.connect(
			func(): SignalBus.upgrade_button_pressed.emit(self, upgrade_type)
		)


func change_claim_state(set_claimed : bool):
	claimed = set_claimed
	
	var sprite = built_sprite if claimed else raw_sprite
	%ResourceSprite.texture = sprite
	
	SignalBus.upgrade_node_claim_status_changed.emit(self, claimed)
	
	level = level + 1 if claimed else 0
	
	%UpgradeLevelLabel.set_visible(claimed)
	%UpgradeLevelLabel.text = "Level " + str(level)
	health_bar.set_visible(claimed)


# To detect bullets?
func _on_area_entered(area):
	print_debug(area.name + " area")


# To detect player and enemies?
func _on_body_entered(body):
	if body is Player: #and not claimed:
		upgrade_button.set_visible(true)	
	if body is EnemyStandard:
		print_debug(body.name + " body")
		change_claim_state(false)
	
	
func _on_body_exited(body):
	if body is Player: #and not claimed:
		upgrade_button.set_visible(false)
