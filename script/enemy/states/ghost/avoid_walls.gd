extends EnemyStateBase

@export var avoid_distance: float = 16.0
@export var avoidance_weight: float = 2.0


func update(delta: float) -> StringName:
	_try_apply_avoidance()
	return &""


func _try_apply_avoidance():
	if not navigation is EnemyNavigationFlying:
		return
	var collision_ray := navigation.get_collision_ray() as RayCast2D
	if collision_ray == null:
		return
	var avoidance := steering.avoid_obstacles(collision_ray, avoid_distance)
	kinematic.add_steering(avoidance, avoidance_weight)
