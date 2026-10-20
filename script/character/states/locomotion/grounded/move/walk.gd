extends GameCharacterStateBase

@export var walk_speed: float = 200
@export var animation_name: StringName = &"walk"


func enter():
	game_character.speed = walk_speed
	game_character.play_animation(animation_name)

func exit():
	game_character.reset_speed()

func process(delta: float) -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "Run"
	
	if Input.is_action_just_pressed("sprint"):
		return "Sprint"
	
	return ""
