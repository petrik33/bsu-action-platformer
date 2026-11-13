class_name Patroling extends PhysicsNodeBase

@export_flags_2d_physics var world_mask: int = 1
@export var min_distance: float = 100.0
@export var max_distance: float = 300.0
@export var sample_step := 8.0
@export var floor_check_depth: float = 256.0
@export var vertical_offset: float = 0.0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const PROBE_OFFSET := Vector2(0.0, -4.0)


func _ready():
	super()
	rng.randomize()

## Returns Vector2.INF if none can be found
func get_home_point() -> Vector2:
	return _ground_position(body.global_position)

## Returns Vector2.INF if none can be found
func get_patrol_point(direction: float) -> Vector2:
	var home_point := get_home_point()
	if home_point == Vector2.INF:
		return Vector2.INF
	
	var selected_distance := rng.randf_range(min_distance, max_distance)
	var horizontal := signf(direction)
	var travel := sample_step
	var patrol_point := home_point

	while travel <= selected_distance:
		var probe := home_point + Vector2(horizontal * travel, 0.0)
		var probe_ground := _ground_position(probe)
		if not _is_clear(home_point, probe):
			break
		if not is_equal_approx(probe_ground.y, home_point.y):
			break
		patrol_point = probe
		travel += sample_step
	
	patrol_point.y -= vertical_offset

	return patrol_point

func _has_ground(point: Vector2) -> bool:
	return _ground_position(point) != Vector2.INF

func _ground_position(point: Vector2) -> Vector2:
	var hit := _ray_intersection(point + PROBE_OFFSET, point + Vector2.DOWN * floor_check_depth)
	if hit.is_empty():
		return Vector2.INF
	return hit["position"]

func _is_clear(from: Vector2, to: Vector2) -> bool:
	var offset_from := from + PROBE_OFFSET
	var offset_to := to + PROBE_OFFSET
	return _ray_intersection(offset_from, offset_to).is_empty()

func _ray_intersection(from: Vector2, to: Vector2) -> Dictionary:
	var query := PhysicsRayQueryParameters2D.create(from, to, world_mask)
	return body.get_world_2d().direct_space_state.intersect_ray(query)
