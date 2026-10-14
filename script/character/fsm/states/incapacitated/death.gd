extends CharacterStateBase

func enter():
	character.animation_finished.connect(_on_animation_finished)
	character.play_animation("death")

func exit():
	character.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished(_anim_name: StringName):
	_transition("idle")
