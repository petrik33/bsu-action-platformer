class_name GhostPassiveState extends EnemyStateBase

@export var floating: Floating

func update(delta: float) -> StringName:
	floating.apply(delta)
	return &""
