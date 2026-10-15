class_name CharacterStateBase extends Node


signal transition_requested(to: StringName)


var character: CharacterBody2D


func init(owner_character: CharacterBody2D):
	character = owner_character

func enter():
	pass

func exit():
	pass

func process() -> StringName:
	return &""

func update_physics(delta: float):
	pass

func post_physics() -> StringName:
	return &""

func _transition(to: StringName):
	transition_requested.emit(to)
