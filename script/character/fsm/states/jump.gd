class_name CharacterStateJump extends CharacterStateBase


func enter(from: CharacterStateBase):
	character.jump()
	character.set_animation("jump_up")


func handle_input() -> StringName:
	if Input.is_action_just_pressed("jump") and character.can_jump():
		character.jump()
	if Input.is_action_just_pressed("click"):
		return "attack"
	return ""


func update() -> StringName:
	if character.is_on_floor():
		return "idle"
	
	if character.velocity.y > 0:
		return "fall"
	
	return ""
