class_name CharacterStateMoveHorizontally extends CharacterStateBase


@export var speed: float = 300.0


func enter(_from: CharacterStateBase):
	character.speed = speed


func update() -> StringName:
	if is_zero_approx(character.velocity.x):
		return "idle"
	
	if not character.is_on_floor():
		return "fall"
	
	return ""
