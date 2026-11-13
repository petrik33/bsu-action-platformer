class_name NavigationFlying extends NavigationBase


@export var avoidance_ray_length: float = 64.0
@export var side_ray_angle: float = deg_to_rad(30)

@export var front_ray: RayCast2D
@export var left_ray: RayCast2D
@export var right_ray: RayCast2D


func _ready() -> void:
	front_ray.target_position = Vector2.RIGHT * avoidance_ray_length
	left_ray.target_position = Vector2.RIGHT.rotated(side_ray_angle) * avoidance_ray_length
	right_ray.target_position = Vector2.RIGHT.rotated(-side_ray_angle) * avoidance_ray_length

func force_update() -> void:
	front_ray.force_raycast_update()
	left_ray.force_raycast_update()
	right_ray.force_raycast_update()

func has_wall_ahead() -> bool:
	force_update()
	return front_ray.is_colliding() or left_ray.is_colliding() or right_ray.is_colliding()

func has_ledge_ahead() -> bool:
	return false

func can_reach(_position: Vector2) -> bool:
	return true

func get_collision_ray() -> RayCast2D:
	force_update()

	if front_ray.is_colliding():
		return front_ray
	if left_ray.is_colliding():
		return left_ray
	if right_ray.is_colliding():
		return right_ray

	return null
