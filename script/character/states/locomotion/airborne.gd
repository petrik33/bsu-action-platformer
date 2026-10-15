extends GameCharacterStateBase


func process() -> StringName:
	if Input.is_action_just_pressed("jump") and game_character.can_jump():
		return "Jump"
		
	if Input.is_action_just_pressed("click"):
		return "Attack"
		
	if Input.is_action_just_pressed("roll"):
		return "Roll"
		
	return ""

func post_physics() -> StringName:
	if game_character.is_on_floor():
		return "Idle"
	return ""
