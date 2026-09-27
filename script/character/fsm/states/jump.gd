class_name CharacterStateJump extends CharacterStateBase


@export var jump_velocity := 300.0


func enter(from: CharacterStateBase):
	character.velocity.y = -jump_velocity
	character.set_animation("jump_up")


func handle_input() -> StringName:
	if Input.is_action_just_pressed("click"):
		return "attack"
	return ""


func update() -> StringName:
	if character.is_on_floor():
		return "idle"
	
	if character.velocity.y > 0:
		return "fall"
	
	return ""
