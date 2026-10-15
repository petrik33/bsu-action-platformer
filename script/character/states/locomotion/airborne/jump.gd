extends GameCharacterStateBase


func enter():
	game_character.play_animation("jump")
	game_character.jump()


func post_physics() -> StringName:
	if game_character.velocity.y > 0:
		return "Fall"
	return ""
