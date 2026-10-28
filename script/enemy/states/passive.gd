extends EnemyCharacterStateBase





func update(_delta: float) -> StringName:
	if perception.has_target():
		return &"Alert"
	
	return &""
