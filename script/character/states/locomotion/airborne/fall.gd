extends GameCharacterStateBase

@export var animation_name: StringName = &"fall"

func enter():
	game_character.play_animation(animation_name)
