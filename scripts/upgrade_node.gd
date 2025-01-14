extends Sprite2D
class_name UpgradeNode


@onready var area_2d := $Area2D


func _ready():
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.area_entered.connect(_on_area_entered)


# To detect bullets?
func _on_area_entered(area):
	print_debug(area)


# To detect player and enemies?
func _on_body_entered(body):
	print_debug(body)
