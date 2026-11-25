extends HeroStateBase

@export var animation: StringName = &"gun_holster"
@export var time: float = 0.4


func enter():
	hero.play_animation(animation, time)
	_state_timer(time, _on_finished)

func _on_finished():
	gun.hide()
	_transition(&"Idle")
