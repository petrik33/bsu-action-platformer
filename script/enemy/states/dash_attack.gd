extends EnemyStateBase

@export var collision_shape: CollisionShape2D
@export var attack_animation: StringName = &"attack"
@export var time: float = 0.8
@export var dash_speed: float = 100.0
@export var target_offset: float = 4.0


func enter() -> void:
	collision_shape.disabled = false
	var dash_target := perception.to_target()
	dash_target.y -= target_offset
	steering.reset()
	kinematic.dash(dash_target.normalized() * dash_speed)
	enemy.face_vector(perception.to_target())
	enemy.play_animation(attack_animation)
	attack.start()
	_schedule_transition(time, &"Chase")

func exit():
	attack.end()
	collision_shape.disabled = true
