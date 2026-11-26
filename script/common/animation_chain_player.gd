class_name AnimationChainPlayer extends Node

signal animation_requested(anim_name: StringName, time: float)

@export var chains: Dictionary[StringName, AnimationChain] = {}
@export var timer: Timer

var _chain: AnimationChain
var _index: int = 0
var _step_time: float = 0.0


func _ready() -> void:
	timer.timeout.connect(_on_step_finished)


func has_chain(anim_name: StringName) -> bool:
	return chains.has(anim_name)

func play(anim_name: StringName, time: float):
	if not chains.has(anim_name):
		return
	
	var chain := chains[anim_name]
	
	if chain == null or chain.animations.is_empty():
		return
		
	_chain = chain
	_index = 0
	_step_time = maxf(time, 0.0) / chain.animations.size()
	_play_step()

func stop() -> void:
	timer.stop()
	_chain = null
	_index = 0


func _on_step_finished():
	_index += 1
	if _index >= _chain.animations.size():
		stop()
	else:
		_play_step() 

func _play_step() -> void:
	var anim_name := _chain.animations[_index]
	animation_requested.emit(anim_name, _step_time)
	timer.start(_step_time)
