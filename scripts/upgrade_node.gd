extends Area2D
class_name UpgradeNode


@export var upgrade_line : Line2D

@export var built_sprite : Texture2D
@export var raw_sprite : Texture2D

@export var upgrade_button : Button
@export var health_component : HealthComponent

@export var chosen_type: UpgradeManager.Type = UpgradeManager.Type.RANDOM

var claimed : bool = false
var level : int = 0

var upgrade_type : UpgradeManager.Type

@export var player : Player

func _ready():	
	upgrade_button.set_visible(false)
	health_component.health_bar.set_visible(false)
	%UpgradeLevelLabel.set_visible(false)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	
	upgrade_type = chosen_type
	if chosen_type == UpgradeManager.Type.RANDOM:
		var types = UpgradeManager.Type.values() as Array
		types.remove_at(types.size() - 1)
		upgrade_type = types.pick_random()
	#upgrade_type = UpgradeManager.Type.SHOT_NUMBER
	upgrade_button.text = UpgradeManager.UPGRADE_NAMES[upgrade_type]
	
	SignalBus.all_health_removed.connect(_on_all_health_removed)
	
	upgrade_button.button_up.connect(
			func(): SignalBus.upgrade_button_pressed.emit(self, upgrade_type)
		)
		
	# emit in ready to re-set on restart
	SignalBus.upgrade_value_changed.emit(upgrade_type, level)


func _on_all_health_removed(node : Node, health_left : bool):
	if (node.get_parent() is UpgradeNode):
		change_claim_state(health_left)
	

func _physics_process(delta):
	if claimed:
		upgrade_line.points[1] = (player.global_position - self.global_position)
	else:
		upgrade_line.points[1] = Vector2.ZERO


func change_claim_state(set_claimed : bool):
	claimed = set_claimed
	
	if not claimed:
		SignalBus.upgrade_value_changed.emit(0, upgrade_type) 
	
	var sprite = built_sprite if claimed else raw_sprite
	%ResourceSprite.texture = sprite
	
	SignalBus.upgrade_node_claim_status_changed.emit(self, claimed)
	
	level = level + 1 if claimed else 0
	SignalBus.upgrade_value_changed.emit(upgrade_type, level)
	
	%UpgradeLevelLabel.set_visible(claimed)
	%UpgradeLevelLabel.text = "Level " + str(level)
	
	health_component.health_bar.set_visible(claimed)
	health_component.health_bar.value = 100 * health_component.health/health_component.start_health


# To detect bullets?
func _on_area_entered(area):
	print_debug(area.name + " area")


# To detect player and enemies?
func _on_body_entered(body):
	if body is Player: #and not claimed:
		upgrade_button.set_visible(true)	
	if body is EnemyStandard and claimed:
		body.crash()
		health_component.take_damage(60)
	
	
func _on_body_exited(body):
	if body is Player: #and not claimed:
		upgrade_button.set_visible(false)
