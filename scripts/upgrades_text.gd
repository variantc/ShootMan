extends RichTextLabel


var upgrade_levels = {}  # Dictionary to store current levels


func _ready():
	# Initialize all upgrade types to level 0
	for type in UpgradeManager.Type.values():
		if type != UpgradeManager.Type.RANDOM:  # Skip RANDOM type
			upgrade_levels[type] = 0
			
	SignalBus.upgrade_value_changed.connect(_on_upgrade_value_changed)
	Refs.world_ready.connect(_on_world_read)


func _on_upgrade_value_changed(upgrade_type: int, level: int, _operation: int = 0):
	upgrade_levels[upgrade_type] = level
	_update_text()


func _on_world_read(_world : World):
	_update_text()

func _update_text() -> void:
	if not Refs.world.DEBUG:
		text = ""
		return
	
	print_debug("Here")
	var debug_text = "[b]Upgrade Levels:[/b]\n"
	
	for type in upgrade_levels.keys():
		var type_name = UpgradeManager.Type.keys()[type]  # Get name from enum
		var level = upgrade_levels[type]
		debug_text += type_name + ": " + str(level) + "\n"
	
	text = debug_text
	
	
