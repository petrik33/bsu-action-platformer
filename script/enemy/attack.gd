class_name EnemyAttack extends Attack

@export var cooldown: float = 0.5
@export var distance: float = 12.0

var _cooldown_left: float = 0.0

func _physics_process(delta: float) -> void:
	if not _is_active and _cooldown_left > 0:
		_cooldown_left -= delta

func is_ready() -> bool:
	return _cooldown_left <= 0

func in_distance(to_target: Vector2) -> bool:
	return to_target.length() <= distance

func end():
	super.end()
	_cooldown_left = cooldown
