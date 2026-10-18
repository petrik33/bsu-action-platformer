class_name EnemyPerception extends Area2D


signal target_spotted(target: CharacterBody2D)
signal target_lost(target: CharacterBody2D)

@export_flags_2d_physics var visibility_mask: int = 1
@export var target_group: StringName = &"player"
@export var forget_delay: float = 0.5
@export var visibility_origin: Node2D

var target: CharacterBody2D
var last_known_position: Vector2

var _candidates: Array[CharacterBody2D] = []
var _lost_time: float = 0.0


func _ready() -> void:
	monitoring = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	if not is_instance_valid(target):
		target_lost.emit(target)
		target = null
	
	if is_instance_valid(target) and _can_see(target):
		last_known_position = target.global_position
		_lost_time = 0.0
		return

	if is_instance_valid(target):
		_lost_time += delta

		if _lost_time < forget_delay:
			return

		target_lost.emit(target)
		target = null

	for candidate in _candidates:
		if not is_instance_valid(candidate):
			continue

		if _can_see(candidate):
			target = candidate
			last_known_position = candidate.global_position
			_lost_time = 0.0
			target_spotted.emit(candidate)
			return


func has_target() -> bool:
	return is_instance_valid(target)


func _can_see(candidate: CharacterBody2D) -> bool:
	var see_from := global_position
	if visibility_origin != null:
		see_from = visibility_origin.global_position
	
	var query := PhysicsRayQueryParameters2D.create(
		see_from,
		candidate.global_position,
		visibility_mask
	)

	var result := get_world_2d().direct_space_state.intersect_ray(query)

	return result.get("collider") == candidate


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group(target_group):
		_candidates.append(body)


func _on_body_exited(body: Node2D) -> void:
	_candidates.erase(body)
