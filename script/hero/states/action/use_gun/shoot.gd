extends HeroStateBase

@export var anim_name: StringName = &"shoot"
@export var next_shot_min_time: float = 0.1
@export var time: float = 0.3
@export var anim_observer: AnimationObserver


func enter():
	if not gun.can_shoot():
		_transition(&"StartReload")
		return
	hero.play_animation(anim_name, time, true)
	anim_observer.subscribe_entered(_on_shoot_frame_entered)
	_state_timer(time, _on_finished)

func exit():
	if anim_observer != null and anim_observer.frame_entered.is_connected(_on_shoot_frame_entered):
		anim_observer.unsubscribe_entered(_on_shoot_frame_entered)

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
