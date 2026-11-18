extends EnemyStateBase


func update(_delta: float) -> StringName:
	if perception.has_target() and not enemy.passive:
		return &"Alert"
	
	return &""
