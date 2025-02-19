extends RichTextLabel




func _ready():
	## Initialize all upgrade types to level 0
	#for type in UpgradeManager.Type.values():
		#if type != UpgradeManager.Type.RANDOM:  # Skip RANDOM type
			#upgrade_levels[type] = 0
			
	SignalBus.upgrade_value_changed.connect(_on_upgrade_value_changed)
	Refs.world_ready.connect(_on_world_ready)


func _on_upgrade_value_changed(upgrade_node : UpgradeNode):
	#upgrade_levels[upgrade_type] = level
	#print_debug(emit_node_name + " Upgrade value changed: " + str(UpgradeManager.Type.keys()[upgrade_type]) + " to level: " + str(level))
	_update_text()


func _on_world_ready(_world : World):
	_update_text()


func _update_text() -> void:
	if not Refs.world.DEBUG:
		text = ""
		return
	
	var debug_text = "Upgrade Levels:\n------------------------\n"
	
	for type in Refs.upgrade_manager.upgrade_levels.keys():
		var type_name = UpgradeManager.Type.keys()[type]  # Get name from enum
		var level = Refs.upgrade_manager.upgrade_levels[type]
		debug_text += type_name + ": " + str(level) + "\n"
	
	text = debug_text
