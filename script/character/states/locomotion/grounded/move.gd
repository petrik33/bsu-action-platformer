extends GameCharacterStateBase


func update(_delta: float) -> StringName:
	if is_zero_approx(game_character.movement_direction):
		return "Idle"
	
	return &""
