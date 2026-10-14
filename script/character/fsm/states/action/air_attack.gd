extends CharacterStateBase


func enter():
	character.animation_finished.connect(_on_animation_finished)
	character.play_animation("attack")

func exit():
	character.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished(_anim_name: StringName):
	_transition("fall")
