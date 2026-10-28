extends EnemyCharacterStateBase


@export var speed: float = 65.0
@export var max_distance: float = 300.0

var direction := 1.0
var origin_x: float

func enter() -> void:
	origin_x = enemy.global_position.x
	direction = enemy.facing_direction()
	enemy.play_animation(&"walk")
	enemy.navigation.force_update()

func process(delta: float) -> void:
	enemy.face_movement()


func update(_delta: float) -> StringName:
	if enemy.navigation.has_obstacles_ahead():
		enemy.stop_horizontal()
		return &"Idle"
	
	enemy.move_horizontal(
		direction,
		speed
	)
	
	if absf(enemy.global_position.x - origin_x) >= max_distance:
		return &"Idle"
	
	if enemy.navigation.has_obstacles_ahead():
		return &"Idle"
	
	return &""
