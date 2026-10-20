extends GameCharacterStateBase

@export var animation_name: StringName = &"run"


func enter():
	game_character.reset_speed()
	game_character.play_animation(animation_name)

func process(delta: float) -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "Walk"
	
	if Input.is_action_just_pressed("sprint"):
		return "Sprint"
	
	return ""
