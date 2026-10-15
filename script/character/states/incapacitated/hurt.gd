extends GameCharacterStateBase

func enter():
	game_character.animation_finished.connect(_on_animation_finished)
	game_character.play_animation("hurt")

func exit():
	game_character.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished(_anim_name: StringName):
	_transition("Idle")
	
