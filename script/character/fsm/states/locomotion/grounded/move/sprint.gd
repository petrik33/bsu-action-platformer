extends CharacterStateBase

@export var sprint_speed: float = 600


func enter():
	character.speed = sprint_speed
	character.play_animation("sprint")

func exit():
	character.reset_speed()

func handle_input() -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "Walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "Run"
	
	return ""
