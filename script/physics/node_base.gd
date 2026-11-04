class_name PhysicsNodeBase extends Node

var body: CharacterBody2D

func _ready():
	body = owner as CharacterBody2D
	if not body:
		push_error("Gravity component must be a child of CharacterBody2D")

func _get_configuration_warnings():
	if not owner is CharacterBody2D:
		return ["Gravity component must be a child of CharacterBody2D"]
	return []
