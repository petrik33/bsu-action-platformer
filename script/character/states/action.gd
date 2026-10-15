extends GameCharacterStateBase


func process() -> StringName:
	if Input.is_action_just_pressed("jump") and game_character.can_jump():
		return "Jump"
	
	return ""
