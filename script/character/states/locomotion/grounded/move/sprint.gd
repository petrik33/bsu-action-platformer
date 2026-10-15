extends GameCharacterStateBase

@export var sprint_speed: float = 600


func enter():
	game_character.speed = sprint_speed
	game_character.play_animation("sprint")

func exit():
	game_character.reset_speed()

func process() -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "Walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "Run"
	
	return ""
