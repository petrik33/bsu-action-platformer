extends HeroStateBase

@export var animation_name: StringName = &"air_attack"
@export var time: float = 0.4

func enter():
	hero.play_animation(animation_name, time)
	_state_timer(time, _on_finished)


func _on_finished():
	if character.is_on_floor():
		_transition(&"Idle")
	else:
		_transition(&"Fall")
