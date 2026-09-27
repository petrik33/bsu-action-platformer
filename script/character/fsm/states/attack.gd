class_name CharacterStateAttack extends CharacterStateBase


func enter(from: CharacterStateBase):
	character.animation_finished.connect(_on_animation_finished)
	character.play_animation("attack")


func exit(to: CharacterStateBase):
	character.animation_finished.disconnect(_on_animation_finished)


func handle_input() -> StringName:
	if Input.is_action_just_pressed("jump") and character.can_jump():
		character.jump()
	return ""
 

func _on_animation_finished(anim_name: StringName):
	if character.is_on_floor():
		_transition("idle")
	else:
		_transition("fall")
