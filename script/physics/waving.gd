class_name Waving extends Node

@export var hover_height: float = 5.0
@export var height_lerp: float = 0.2
@export var wave_amplitude: float = 2.0
@export var wave_frequency: float = 2.0

var time_passed: float = 0.0
var body: CharacterBody2D
@export var ground_ray: RayCast2D

func _ready() -> void:
	body = get_parent() as CharacterBody2D
	if not body:
		push_error("Waving component must be a child of CharacterBody2D")

func set_ground_ray(ray: RayCast2D) -> void:
	ground_ray = ray

func apply_wave(delta: float) -> void:
	if not ground_ray or not body:
		return

	ground_ray.force_raycast_update()
	if ground_ray.is_colliding():
		time_passed += delta
		
		var ground_y = ground_ray.get_collision_point().y
		var wave_offset = sin(time_passed * wave_frequency) * wave_amplitude
		var target_y = ground_y - hover_height + wave_offset
		
		body.position.y = lerp(body.position.y, target_y, height_lerp)
