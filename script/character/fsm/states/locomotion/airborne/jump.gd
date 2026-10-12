extends CharacterStateBase


func enter():
	character.play_animation("Jump")
	character.jump()


func post_physics() -> StringName:
	if character.velocity.y > 0:
		return "Fall"
	return ""
