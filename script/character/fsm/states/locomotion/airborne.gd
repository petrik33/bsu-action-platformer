extends CharacterStateBase


func handle_input() -> StringName:
	if Input.is_action_just_pressed("jump") and character.can_jump():
		return "Jump"
		
	if Input.is_action_just_pressed("click"):
		return "AirAttack"
		
	if Input.is_action_just_pressed("roll"):
		return "Roll"
		
	return ""

func update() -> StringName:
	if character.is_on_floor():
		return "Grounded"
	return ""
