class_name CharacterStateTimer

var state_name: StringName
var remaining: float
var callback: Callable

func _init(owner_name: StringName, time: float, callable: Callable) -> void:
	state_name = owner_name
	remaining = time
	callback = callable
