class_name CharacterStateFall extends CharacterStateBase


func enter(from: CharacterStateBase):
	character.set_animation("jump_down")


func handle_input() -> StringName:
	if Input.is_action_just_pressed("jump") and character.can_jump():
		return "jump"
	if Input.is_action_just_pressed("click"):
		return "attack"
	return ""


func update() -> StringName:
	if character.is_on_floor():
		return "idle"
	
	return ""
