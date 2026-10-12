extends CharacterStateBase


func post_physics() -> StringName:
	if is_zero_approx(character.movement_direction):
		return "idle"
	
	if not character.is_on_floor():
		return "fall"
	
	return ""
