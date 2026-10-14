extends CharacterStateBase


func post_physics() -> StringName:
	if is_zero_approx(character.movement_direction):
		return "Idle"
	
	return ""
