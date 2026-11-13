class_name Resistance extends PhysicsNodeBase


@export var force: float = 500.0
@export var enabled: bool = false


func apply(delta: float) -> void:
	if not enabled:
		return

	body.velocity.x = move_toward(body.velocity.x, 0.0, force * delta)
