class_name CharacterStateMoveHorizontally extends CharacterStateBase


@export var speed: float = 300.0


func update_physics(delta: float) -> StringName:
	var direction := Input.get_axis("left", "right")
	if direction == 0:
		return "idle"
	
	character.update_horizontal_velocity(speed, direction)
	character.flip(direction)
	
	if not character.is_on_floor():
		return "fall"
	
	return ""
