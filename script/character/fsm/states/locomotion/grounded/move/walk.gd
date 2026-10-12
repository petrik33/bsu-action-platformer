class_name CharacterStateWalk extends CharacterStateMoveHorizontally

@export var walk_speed: float = 200


func enter():
	character.speed = walk_speed
	character.play_animation("walk")

func exit():
	character.reset_speed()

func handle_input() -> StringName:
	if Input.is_action_just_pressed("walk"):
		return "Run"
	
	if Input.is_action_just_pressed("sprint"):
		return "Sprint"
	
	return ""
