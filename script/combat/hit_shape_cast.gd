class_name HitShapeCast extends ShapeCast2D

func sweep(to: Vector2) -> Array[Dictionary]:
	target_position = to_local(to)
	force_shapecast_update()

	var hits: Array[Dictionary] = []
	var direction := (to - global_position).normalized()
	for i in get_collision_count():
		var point := get_collision_point(i)
		hits.append({
			"collider": get_collider(i),
			"point": point,
			"normal": get_collision_normal(i),
			"distance": (point - global_position).dot(direction),
		})
	hits.sort_custom(_sort_by_distance)
	return hits


func _sort_by_distance(a: Dictionary, b: Dictionary) -> bool:
	return a["distance"] < b["distance"]
