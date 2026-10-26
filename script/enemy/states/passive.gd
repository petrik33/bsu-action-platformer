extends EnemyCharacterStateBase


func process(delta: float) -> StringName:
	if enemy.perception.has_target():
		return &"Alert"

	return &""
