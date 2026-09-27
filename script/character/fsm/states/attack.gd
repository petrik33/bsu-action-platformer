class_name CharacterStateAttack extends CharacterStateBase


func enter(from: CharacterStateBase):
	character.animation_finished.connect(_on_animation_finished)
	character.play_animation("attack")


func exit(to: CharacterStateBase):
	character.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished(anim_name: StringName):
	_transition("idle")
