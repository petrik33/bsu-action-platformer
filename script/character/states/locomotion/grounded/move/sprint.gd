extends GameCharacterStateBase

@export var sprint_speed: float = 600
@export var animation_name: StringName = &"sprint"


func enter():
	game_character.speed = sprint_speed
	game_character.play_animation(animation_name)

func exit():
	game_character.reset_speed()




func update(_delta: float) -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "Walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "Run"
	
	return &""
