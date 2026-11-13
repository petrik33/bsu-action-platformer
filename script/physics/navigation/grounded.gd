class_name NavigationGrounded extends NavigationBase

@export_flags_2d_physics var world_mask: int = 1
@export var wall_check: RayCast2D
@export var floor_check: RayCast2D

const WALL_PROBE_OFFSET = Vector2(0.0, 4.0)


func force_update():
	wall_check.force_raycast_update()
	floor_check.force_raycast_update()

func has_wall_ahead() -> bool:
	return wall_check.is_colliding()

func has_ledge_ahead() -> bool:
	return not floor_check.is_colliding()

func can_reach(point: Vector2) -> bool:
	if point.y < global_position.y:
		return false
	
	return _is_clear(global_position, point)

func _is_clear(from: Vector2, to: Vector2) -> bool:
	var offset_from := from + WALL_PROBE_OFFSET
	var offset_to := to + WALL_PROBE_OFFSET
	return _ray_intersection(offset_from, offset_to).is_empty()

func _ray_intersection(from: Vector2, to: Vector2) -> Dictionary:
	var query := PhysicsRayQueryParameters2D.create(from, to, world_mask)
	return get_world_2d().direct_space_state.intersect_ray(query)
