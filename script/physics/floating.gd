class_name FloatingComponent extends Node

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
		push_error("FloatingComponent must be a child of CharacterBody2D")

func _physics_process(delta: float) -> void:
	if not body: return
	
	_time += delta
	
	# 1. Calculate Ground-Following Target
	var target_y = body.global_position.y
	if ground_ray and ground_ray.is_colliding():
		var ground_y = ground_ray.get_collision_point().y
		target_y = ground_y - hover_height
	
	# 2. Add Sinusoidal Waving
	var wave_offset = sin(_time * wave_frequency) * wave_amplitude
	target_y += wave_offset
	
	# 3. Blend with Velocity
	# Instead of setting position.y directly, we calculate the velocity 
	# needed to reach the target_y. This blends perfectly with move_and_slide().
	var diff = target_y - body.global_position.y
	body.velocity.y = lerp(body.velocity.y, diff * 60.0, height_lerp)
