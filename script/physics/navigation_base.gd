@abstract
class_name NavigationBase extends Node2D


@abstract func force_update()
@abstract func has_wall_ahead() -> bool
@abstract func has_ledge_ahead() -> bool
@abstract func can_reach(point: Vector2) -> bool

func has_obstacles_ahead() -> bool:
	return has_wall_ahead() or has_ledge_ahead()

func get_collision_ray() -> RayCast2D:
	return null
