extends GameCharacterStateBase


func enter():
	game_character.reset_speed()
	game_character.play_animation("run")

func process(delta: float) -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "Walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "Sprint"
	
	return ""
