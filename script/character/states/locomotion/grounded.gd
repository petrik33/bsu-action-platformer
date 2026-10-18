extends GameCharacterStateBase


func process(delta: float) -> StringName:
	if Input.is_action_just_pressed("jump"):
		return "Jump"
	
	if Input.is_action_just_pressed("click"):
		return "Attack"
	
	if Input.is_action_just_pressed("roll"):
		return "Roll"
	
	return ""

func post_physics() -> StringName:
	if not game_character.is_on_floor():
		return "Fall"
	
	return ""
