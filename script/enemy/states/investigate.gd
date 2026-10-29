extends EnemyStateBase

@export var walk_animation_name: StringName = &"walk"
@export var search_animation_name: StringName = &"walk"
@export var search_speed: float = 120.0
@export var arrival_distance: float = 16.0
@export var search_duration: float = 3.5

var _remaining_search_time: float = 0.0
var _look_direction: float = 1.0


func enter() -> void:
	if perception.has_target():
		_transition(&"Chase")
		return
	
	_remaining_search_time = search_duration

	var to_target := perception.to_target()
	_look_direction = signf(to_target.x)
	
	if _try_search():
		return
	_look_direction = -_look_direction
	if _try_search():
		return
	_transition(&"Idle")



func update(delta: float) -> StringName:
	_remaining_search_time -= delta
	if _remaining_search_time <= 0.0:
		return &"Idle"
	
	if perception.has_target():
		return &"Chase"
	
	if not _can_search():
		_look_direction = -_look_direction
		if not _try_search():
			return &"Idle"
	
	return &""


func _try_search() -> bool:
	if _can_search():
		_begin_search()
		return true
	return false

func _begin_search() -> void:
	steering.set_horizontal_velocity(_look_direction * search_speed)
	enemy.face(_look_direction)

func _can_search() -> bool:
	if absf(perception.to_target().x) <= arrival_distance:
		return false
	if navigation.has_obstacles_ahead():
		return false
	return true
