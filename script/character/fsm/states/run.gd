class_name CharacterStateRun extends CharacterStateMoveHorizontally


func enter(from: CharacterStateBase):
	character.play_animation("run")


func handle_input(delta: float) -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "sprint"
	
	if Input.is_action_just_pressed("jump"):
		return "jump"
	
	if Input.is_action_just_pressed("click"):
		return "attack"
	
	return ""
