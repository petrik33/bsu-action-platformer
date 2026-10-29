class_name Floating extends Node2D

@export_group("Hover Settings")
@export var hover_height: float = 20.0
@export var height_lerp: float = 0.1
@export var ground_ray: RayCast2D

@export_group("Waving Settings")
@export var wave_amplitude: float = 10.0
@export var wave_frequency: float = 2.0

var body: CharacterBody2D

var _time: float = 0.0

func _ready() -> void:
	body = get_parent() as CharacterBody2D
	if not body:
		push_error("Floating component must be a child of CharacterBody2D")

func _get_configuration_warnings():
	if not get_parent() is CharacterBody2D:
		return ["Floating component must be a child of CharacterBody2D"]
	return []

func apply(delta: float):
	ground_ray.force_raycast_update()
	if ground_ray.is_colliding():
		_time += delta
		
		var ground_y = ground_ray.get_collision_point().y
		var wave_offset = sin(_time * wave_frequency) * wave_amplitude
		var target_y = ground_y - hover_height + wave_offset
		
		var diff = target_y - body.global_position.y
		body.velocity.y = diff * (height_lerp / delta)
