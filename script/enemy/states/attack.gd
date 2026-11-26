class_name EnemyAttackState extends EnemyStateBase

@export var collision_shape: CollisionShape2D
@export var attack_animation: StringName = &"attack"
@export var attack_frame: int = 5
@export var time: float = 0.5
@export var stop_behavior: SteeringBehaviorBase


func enter() -> void:
	enemy.face_vector(perception.to_target())
	enemy.play_animation(attack_animation, time)

	var enter_time := enemy.get_frame_time(attack_animation, attack_frame, time)
	var exit_time := enemy.get_frame_exit_time(attack_animation, attack_frame, time)
	if enter_time >= 0.0:
		_call_after(enter_time, _on_attack_frame)
	if exit_time >= 0.0:
		_call_after(exit_time, _on_attack_frame_exit)

	_schedule_transition(time, &"Chase")


func exit():
	if attack.is_active():
		_on_attack_frame_exit()


func update(_delta: float) -> StringName:
	steering.use(stop_behavior)
	return &""

func _on_attack_frame():
	attack.start()
	collision_shape.disabled = false

func _on_attack_frame_exit():
	attack.end()
	collision_shape.disabled = true
