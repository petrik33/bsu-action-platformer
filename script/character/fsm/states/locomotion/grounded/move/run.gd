extends CharacterStateBase


func enter():
	character.reset_speed()
	character.play_animation("run")

func handle_input() -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "sprint"
	
	return ""
