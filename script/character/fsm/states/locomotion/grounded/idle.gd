extends CharacterStateBase


func enter():
	character.play_animation("idle")

func post_physics() -> StringName:	
	if not is_zero_approx(character.movement_direction):
		return "Run"
	
	return ""
