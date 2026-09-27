class_name CharacterStateBase extends Node


signal transition_requested(to: StringName)


var character: Character


func enter(from: CharacterStateBase):
	pass


func exit(to: CharacterStateBase):
	pass


func handle_input(delta: float) -> StringName:
	return &""


func update_physics(delta: float) -> StringName:
	return &""


func _transition(to: StringName):
	transition_requested.emit(to)
