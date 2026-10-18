extends GameCharacterStateBase


func process(delta: float) -> StringName:
	if Input.is_action_just_pressed("jump") and game_character.can_jump():
		return "Jump"
	
	return ""


func post_physics() -> StringName:
	game_character.face_movement()
	return &""
