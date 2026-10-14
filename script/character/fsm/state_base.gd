class_name CharacterStateBase extends Node


signal transition_requested(to: StringName)


var character: GameCharacter


func enter():
	pass

func exit():
	pass

func handle_input() -> StringName:
	return &""

func update_physics(delta: float):
	pass

func post_physics() -> StringName:
	return &""

func _transition(to: StringName):
	transition_requested.emit(to)
