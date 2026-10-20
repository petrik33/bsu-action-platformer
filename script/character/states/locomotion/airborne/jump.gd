extends GameCharacterStateBase

@export var animation_name: StringName = &"jump"

func enter():
	game_character.play_animation(animation_name)
	game_character.jump()


func post_physics() -> StringName:
	if game_character.velocity.y > 0:
		return "Fall"
	return ""
