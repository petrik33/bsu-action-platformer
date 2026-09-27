class_name CharacterStateWalk extends CharacterStateMoveHorizontally


func enter(from: CharacterStateBase):
	super.enter(from)
	character.set_animation("walk")


func handle_input() -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "run"
	
	if Input.is_action_just_pressed("sprint"):
		return "sprint"
	
	if Input.is_action_just_pressed("click"):
		return "attack"
	
	return ""
