extends CharacterStateBase


func handle_input() -> StringName:
	if Input.is_action_just_pressed("jump") and character.can_jump():
		return "Jump"
	
	return ""
