extends EnemyCharacterStateBase


func process(delta: float) -> StringName:
	if perception.has_target():
		return &"Alert"

	return &""
