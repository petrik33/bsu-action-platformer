class_name AttackHandler extends Node

@export var hit_box_collision_shape: CollisionShape2D


func _ready() -> void:
	if not hit_box_collision_shape:
		return
	
	hit_box_collision_shape.disabled = true

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not hit_box_collision_shape:
		warnings.append("Target CollisionShape2D is missing.")
	return warnings


func enable():
	hit_box_collision_shape.disabled = false

func disable():
	hit_box_collision_shape.disabled = true
