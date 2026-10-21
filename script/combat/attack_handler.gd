class_name AttackHandler extends Node

@export var observer: AnimationObserver
@export var hit_box_collision_shape: CollisionShape2D


func _ready() -> void:
	if not observer or not hit_box_collision_shape:
		return
	
	hit_box_collision_shape.disabled = true
	
	observer.frame_entered.connect(func(): hit_box_collision_shape.disabled = false)
	observer.frame_exited.connect(func(): hit_box_collision_shape.disabled = true)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not observer:
		warnings.append("AnimationObserver is missing.")
	if not hit_box_collision_shape:
		warnings.append("Target CollisionShape2D is missing.")
	return warnings
