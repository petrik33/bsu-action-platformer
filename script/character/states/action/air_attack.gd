extends GameCharacterStateBase

@export var animation_name: StringName = &"air_attack"

func enter():
	game_character.animation_finished.connect(_on_animation_finished)
	game_character.play_animation(animation_name)

func exit():
	game_character.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished():
	if character.is_on_floor():
		_transition(&"Idle")
	else:
		_transition(&"Fall")
