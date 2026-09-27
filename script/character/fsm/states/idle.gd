class_name CharacterStateIdle extends CharacterStateBase


func enter(_from: CharacterStateBase):
	character.set_animation("idle")
	character.reset_speed()
	character.reset_jumps()


func handle_input() -> StringName:
	var direction := Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump"):
		return "jump"
	
	if Input.is_action_just_pressed("click"):
		return "attack"
	
	if direction != 0:
		return "run"
	
	return ""
