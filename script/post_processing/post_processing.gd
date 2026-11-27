class_name PostProcessing extends Node

## Runs child PostProcessEffect layers in tree order.
##
## Each effect is its own CanvasLayer because Godot refreshes the screen
## texture between canvas layers, but not between items inside one layer.
## The node assigns layer = base_layer + index in tree order, so reordering
## the children in the editor reorders the effects.

@export var base_layer: int = 100


func _ready() -> void:
	child_entered_tree.connect(_on_children_changed)
	child_exiting_tree.connect(_on_children_changed)
	_refresh_layers()


func _refresh_layers() -> void:
	var index := 0
	for child in get_children():
		if child is PostProcessEffect:
			child.layer = base_layer + index
			index += 1


func _on_children_changed(_node: Node) -> void:
	_refresh_layers.call_deferred()
