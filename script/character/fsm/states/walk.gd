class_name CharacterStateWalk extends CharacterStateMoveHorizontally


func enter(_from: CharacterStateBase):
	character.play_animation("walk")


func handle_input(delta: float) -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "run"
	
	if Input.is_action_just_pressed("sprint"):
		return "sprint"
	
	if Input.is_action_just_pressed("click"):
		return "attack"
	
	return ""
