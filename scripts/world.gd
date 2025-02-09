extends Node2D
class_name World

@export_category("DEBUG")
@export var DEBUG : bool = false

@export var upgrade_nodes : Array[UpgradeNode]
var claimed_upgrade_nodes : Array[UpgradeNode]

@onready var sound_manager := $SoundManager as SoundManager
@onready var drop_spawner := $DropSpawner as DropSpawner
@onready var enemy_spawner := $EnemySpawner as EnemySpawner
@onready var score_text := %ScoreText as RichTextLabel

var offset_to_player : Vector2


func _ready():
	Refs. register_world(self)
	
	SignalBus.drop_picked_up.connect(_on_drop_pickedup)
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	SignalBus.upgrade_node_claim_status_changed.connect(_on_upgrade_node_claim_state_changed)


func _on_enemy_killed(enemy, audio):
	sound_manager.play_sound(audio.stream)
	
	# TODO: Move to another script?:
	# we want to check if the enemy has just been killed so that we don't
	# spawn multiple drops for an enemy shot by two bullets at once
	if enemy in enemy_spawner.enemy_list:
		# remove from the enemy_list here:
		enemy_spawner.remove_enemy_from_list(enemy)
		drop_spawner.spawn_drop(enemy.global_position)
	else:
		print_debug("enemy not in enemy list?")


func _on_drop_pickedup(audio : AudioStreamPlayer2D):
	sound_manager.play_sound(audio.stream)
	score_text.score += 1


func _on_upgrade_node_claim_state_changed(node : UpgradeNode, claimed : bool):
	if node in claimed_upgrade_nodes and not claimed:
		claimed_upgrade_nodes.remove_at(claimed_upgrade_nodes.find(node))
	
	if node not in claimed_upgrade_nodes and claimed:
		claimed_upgrade_nodes.append(node)

	if DEBUG:	
		for n in claimed_upgrade_nodes:
			print_debug("claimed nodes: " + str(len(claimed_upgrade_nodes)) + " " + n.name)
