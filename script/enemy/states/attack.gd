class_name EnemyAttackState extends EnemyStateBase

@export var cooldown: float = 1.2
@export var attack_animation: StringName = &"attack"
@export var time: float = 0.5
@export var attack_distance := 16.0

var _last_attack_time_msec: int = 0


func enter() -> void:
	_last_attack_time_msec = Time.get_ticks_msec()
	enemy.face_vector(perception.to_target())
	enemy.play_animation(attack_animation, time)
	_state_timer(time, _on_finished)

func update(delta: float) -> StringName:
	kinematic.add_steering(steering.hstop())
	return &""

func can_attack(to_target: Vector2) -> bool:
	if absf(to_target.length()) > attack_distance:
		return false 
	return is_ready()

func is_ready() -> bool:
	return Time.get_ticks_msec() >= _last_attack_time_msec + int(cooldown * 1000.0)


func _on_finished() -> void:
	_transition(&"Chase")
