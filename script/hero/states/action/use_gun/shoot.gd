extends HeroStateBase

@export var anim_name: StringName = &"shoot"
@export var fire_frame: int = 0
@export var next_shot_min_time: float = 0.1
@export var time: float = 0.3


func enter():
	if not gun.can_shoot():
		_transition(&"StartReload")
		return
	hero.play_animation(anim_name, time, true)
	var fire_time := hero.get_frame_time(anim_name, fire_frame, time)
	if fire_time >= 0.0:
		_call_after(fire_time, _on_shoot_frame_entered)
	_state_timer(time, _on_finished)

func update(_delta: float) -> StringName:
	if Input.is_action_just_pressed("click"):
		_transition_after(next_shot_min_time, &"Shoot")
	return &""


func _on_shoot_frame_entered():
	gun.fire()

func _on_finished():
	if not gun.can_shoot():
		_transition(&"StartReload")
	elif Input.is_action_pressed("aim"):
		_transition(&"AimIdle")
	else:
		_transition(&"Idle")
