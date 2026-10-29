class_name Gravity extends Node

@export var value: float = 900

var body: CharacterBody2D

func _ready():
	body = get_parent() as CharacterBody2D
	if not body:
		push_error("Gravity component must be a child of CharacterBody2D")

func _get_configuration_warnings():
	if not get_parent() is CharacterBody2D:
		return ["Gravity component must be a child of CharacterBody2D"]
	return []


func apply(delta: float):
	if body:
		body.velocity.y += value * delta
