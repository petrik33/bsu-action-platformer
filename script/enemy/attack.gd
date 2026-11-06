class_name EnemyAttack extends Node


@export var hit_box: HitBox
@export var collision_shape: CollisionShape2D
@export var cooldown: float = 0.5

var _cooldown_left: float = 0.0
var _is_active: bool


func _physics_process(delta: float) -> void:
	if not _is_active and _cooldown_left > 0:
		_cooldown_left -= delta


func is_ready() -> bool:
	return _cooldown_left <= 0

func start():
	collision_shape.disabled = false

func end():
	collision_shape.disabled = true
	_cooldown_left = cooldown
