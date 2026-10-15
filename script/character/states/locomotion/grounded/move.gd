extends GameCharacterStateBase


func post_physics() -> StringName:
	if is_zero_approx(game_character.movement_direction):
		return "Idle"
	
	return ""
