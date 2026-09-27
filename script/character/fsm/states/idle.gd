class_name CharacterStateIdle extends CharacterStateBase


func enter(_from: CharacterStateBase):
	character.play_animation("idle")


func handle_input(delta: float) -> StringName:
	var direction := Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump"):
		return "jump"
	
	if Input.is_action_just_pressed("click"):
		return "attack"
	
	if direction != 0:
		return "run"
	
	return ""


func update_physics(delta: float) -> StringName:
	character.velocity.x = 0
	return ""
