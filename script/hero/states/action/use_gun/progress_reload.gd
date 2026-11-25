extends HeroStateBase

@export var animation: StringName = &"reload"
@export var time: float = 0.5


func enter():
	hero.play_animation(animation, time)
	_state_timer(time, _on_finished)

func _on_finished():
	gun.finish_reload()
	if Input.is_action_pressed("aim"):
		_transition(&"StartAim")
	else:
		_transition(&"Idle")
