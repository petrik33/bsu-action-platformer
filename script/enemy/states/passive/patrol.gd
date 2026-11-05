extends EnemyStateBase

@export var speed: float = 65.0
@export var max_distance: float = 300.0

var direction := Vector2.RIGHT
var origin_x: float

@export var walk_animation: StringName = &"walk"

func enter() -> void:
	origin_x = enemy.global_position.x
	direction = Vector2(enemy.facing_direction(), 0.0)
	enemy.play_animation(walk_animation)
	enemy.navigation.force_update()

func process(_delta: float) -> void:
	enemy.face_movement()

func update(delta: float) -> StringName:
	if enemy.navigation.has_obstacles_ahead():
		return &"Idle"
	
	kinematic.add_steering(steering.velocity_match(direction * speed))
	
	if absf(enemy.global_position.x - origin_x) >= max_distance:
		return &"Idle"
	
	if enemy.navigation.has_obstacles_ahead():
		return &"Idle"
	
	return &""
