class_name Gravity extends PhysicsNodeBase

@export var value: float = 900

func apply(delta: float):
	if body:
		body.velocity.y += value * delta
