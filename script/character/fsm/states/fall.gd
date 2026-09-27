class_name CharacterStateFall extends CharacterStateBase


@export var air_roam_speed: float = 300.0


var jump_speed: float


func enter(from: CharacterStateBase):
	jump_speed = abs(character.velocity.x)
	if jump_speed <= 0:
		jump_speed = air_roam_speed
	character.play_animation("jump_down")


func handle_input(delta: float) -> StringName:
	if Input.is_action_just_pressed("click"):
		return "attack"
	return ""


func update_physics(delta: float) -> StringName:
	var direction := Input.get_axis("left", "right")
	
	character.update_horizontal_velocity(jump_speed, direction)
	if direction != 0:
		character.flip(direction)

	if character.is_on_floor():
		return "idle"
	
	return ""
