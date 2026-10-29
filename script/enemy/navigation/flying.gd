class_name EnemyNavigationFlying extends EnemyNavigationBsae

@export var avoidance_ray_length: float = 64.0
@export var side_ray_angle: float = deg_to_rad(30)

@export var front_ray: RayCast2D
@export var left_ray: RayCast2D
@export var right_ray: RayCast2D

var body: CharacterBody2D

func _ready() -> void:
	body = get_parent() as CharacterBody2D
	if not body:
		push_error("Flying navigation must be a child of CharacterBody2D")

func _get_configuration_warnings():
	if not get_parent() is CharacterBody2D:
		return ["Flying navigation must be a child of CharacterBody2D"]
	return []


func force_update() -> void:
	var dir = body.velocity.normalized()
	
	front_ray.target_position = dir * avoidance_ray_length
		
	var left_dir = dir.rotated(side_ray_angle)
	left_ray.target_position = left_dir * avoidance_ray_length
	
	var right_dir = dir.rotated(-side_ray_angle)
	right_ray.target_position = right_dir * avoidance_ray_length
	
	front_ray.force_raycast_update()
	left_ray.force_raycast_update()
	right_ray.force_raycast_update()

func has_obstacles_ahead() -> bool:
	force_update()
	return front_ray.is_colliding() or left_ray.is_colliding() or right_ray.is_colliding()

func get_avoidance_vector() -> Vector2:
	force_update()
	var avoidance = Vector2.ZERO
	
	if front_ray.is_colliding():
		avoidance -= front_ray.get_collision_normal()
	if left_ray.is_colliding():
		avoidance -= left_ray.get_collision_normal()
	if right_ray.is_colliding():
		avoidance -= right_ray.get_collision_normal()
		
	return avoidance.normalized()
