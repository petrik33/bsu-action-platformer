extends GameCharacterStateBase


func enter():
	game_character.play_animation("idle")

func update(_delta: float) -> StringName:	
	if not is_zero_approx(game_character.movement_direction):
		return "Run"
	
	return &""
