@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type(
		"AnimatedMotionTrackerTool",
		"Node",
		preload("animated_motion_tracker.gd"),
		preload("icon.svg")
	)

func _exit_tree() -> void:
	remove_custom_type("AnimatedMotionTrackerTool")
