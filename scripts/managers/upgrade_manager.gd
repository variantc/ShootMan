extends Node
class_name UpgradeManager


enum Type {
	SHOT_NUMBER,
	SHOT_TIME,
	SHOT_SPREAD,
	SHOT_LIFETIME,
	SHOT_SPEED,
	PLAYER_SPEED,
	PLAYER_ANG_ACC,
	RANDOM
}

enum WeaponType {
	SHOT_NUMBER,
	SHOT_TIME,
	SHOT_SPREAD,
	SHOT_LIFETIME,
	SHOT_SPEED
}

enum PlayerType {
	PLAYER_SPEED,
	PLAYER_ANG_ACC
}

static var Operation = { 	# NOT YET USED
	ADD = 0,
	MULTIPLY = 1
}


static var UPGRADE_NAMES = { 
	Type.SHOT_NUMBER: "+ Shot Number",
	Type.SHOT_TIME: "- Reduce Shot Time",
	Type.SHOT_SPREAD: "+ Shot Spread",
	Type.SHOT_LIFETIME: "+ Shot Range",
	Type.SHOT_SPEED: "+ Shot Range",
	Type.PLAYER_SPEED: "+ Player Speed",
	Type.PLAYER_ANG_ACC: "+ Player Turning"  
}

var upgrade_levels = {}  # Track total level from all claimed nodes
var claimed_nodes_levels = {}  # Track individual node contributions

@export_group("Settings")
@export var base_upgrade_cost := 0

@export_group("References")
@export var score_text: ScoreText
@export var upgrade_audio_stream : AudioStream
@export var failed_audio_stream : AudioStream


func _ready():
	SignalBus.upgrade_button_pressed.connect(_on_upgrade_button_pressed)
	SignalBus.upgrade_value_changed.connect(_on_upgrade_value_changed)
	
	# NOT USED AT THE MOMENT:
	SignalBus.debug_upgrade_button_pressed.connect(_on_debug_upgrade)
	
	# Initialize tracking dictionaries
	for type in Type.values():
		if type != Type.RANDOM:
			upgrade_levels[type] = 0
			claimed_nodes_levels[type] = {}
	Refs.register_node(self)


func register_upgrade_node(node: UpgradeNode) -> void:
	if node.upgrade_type in claimed_nodes_levels:
		claimed_nodes_levels[node.upgrade_type][node.get_instance_id()] = 0


func _on_upgrade_value_changed(upgrade_node : UpgradeNode):
	var max_level = 0
	for n in Refs.world.claimed_upgrade_nodes:
		var node = n as UpgradeNode
		if upgrade_node.upgrade_type == node.upgrade_type:
			max_level = max(node.level, max_level)
	
	#var upgrade_name = UpgradeManager.Type.keys()[upgrade_node.upgrade_type]
	
	upgrade_node.shoot_component.current_weapon.apply_upgrade(
		UpgradeManager.Type.SHOT_TIME, 
		upgrade_node.level
		)
	
	update_node_level(upgrade_node, max_level)


func update_node_level(node: UpgradeNode, level: int) -> void:
	var type = node.upgrade_type
	var node_id = node.get_instance_id()
	
	claimed_nodes_levels[type][node_id] = level
	
	var highest_level = 0
	for node_level in claimed_nodes_levels[type].values():
		highest_level = max(highest_level, node_level) 

	upgrade_levels[type] = highest_level
	apply_upgrade(type)


func apply_upgrade(type: int) -> void:
	var type_name = Type.keys()[type]
	
	if type_name in PlayerType.keys():
		Refs.player.movement_resource.apply_upgrade(type, upgrade_levels[type])
	elif type_name in WeaponType.keys():
		Refs.player.shoot_component.current_weapon.apply_upgrade(type, upgrade_levels[type])


func _on_debug_upgrade():
	push_warning("UpgradeManager._on_debug_upgrade not implemented")


func _on_upgrade_button_pressed(upgrade_node: UpgradeNode, upgrade_type: int):
	# Testing against upgrade base cost time the node's upgrade level for scaling
	# + 1 because starts at level zero
	var upgrade_cost = base_upgrade_cost * (upgrade_node.level + 1)
	if score_text.score >= upgrade_cost:
		score_text.score -= upgrade_cost
		upgrade_levels[upgrade_type] += 1
		
		apply_upgrade(upgrade_type)
		
		%SoundManager.play_sound(upgrade_audio_stream)
		upgrade_node.change_claim_state(true)
		SignalBus.upgrade_level_changed.emit(upgrade_type, upgrade_levels[upgrade_type])
	else:
		%SoundManager.play_sound(failed_audio_stream)
