class_name EnemyAttackState extends EnemyStateBase

@export var animation_observer: AnimationObserver
@export var collision_shape: CollisionShape2D
@export var attack_animation: StringName = &"attack"
@export var time: float = 0.5
@export var stop_behavior: SteeringBehaviorBase


func enter() -> void:
	animation_observer.frame_entered.connect(_on_attack_frame)
	animation_observer.frame_exited.connect(_on_attack_frame_exit)
	enemy.face_vector(perception.to_target())
	enemy.play_animation(attack_animation, time)
	_state_timer(time, _on_finished)


func exit():
	animation_observer.frame_entered.disconnect(_on_attack_frame)
	animation_observer.frame_exited.disconnect(_on_attack_frame_exit)
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

func _on_finished() -> void:
	_transition(&"Chase")
