class_name HeroAttackState extends HeroStateBase

@export var lock_speed_multiplier: float = 0.1
@export var combo_animations: Array[StringName] = [&"attack", &"attack2", &"attack3"]
@export var attacks: Array[Attack] = []
@export var animation_time: Array[float] = [-1.0, -1.0, -1.0]
@export var cancel_frames: Array[int] = []

var combo_index: int = 0
var combo_buffered: bool = false
var can_cancel: bool = false


func enter():
	if combo_buffered and combo_index < combo_animations.size() - 1:
		combo_index += 1
	else:
		combo_index = 0
	
	combo_buffered = false
	can_cancel = false

	_start_attack()

func exit():
	attacks[combo_index].end()

func update(_delta: float) -> StringName:
	hero.move_horizontally(lock_speed_multiplier)
	
	if Input.is_action_just_pressed("click"):
		if can_cancel:
			_transition(&"Attack")
		else:
			combo_buffered = true
		
	return &""

func _start_attack():
	var anim_name := combo_animations[combo_index]
	var time := animation_time[combo_index]
	if time < 0:
		time = 0.4
	
	var attack := attacks[combo_index]
	attack.start()
	hero.play_animation(anim_name, time)
	_state_timer(time, _on_finished)
	_schedule_cancel(anim_name, time)

func _schedule_cancel(anim_name: StringName, time: float):
	if combo_index >= combo_animations.size() - 1:
		return
	if combo_index >= cancel_frames.size():
		return
	var cancel_time := hero.get_frame_time(anim_name, cancel_frames[combo_index], time)
	if cancel_time >= 0.0:
		_call_after(cancel_time, _on_cancel_frame)

func _on_cancel_frame():
	if combo_buffered:
		_transition(&"Attack")
	else:
		can_cancel = true

func _on_finished():
	if combo_buffered:
		_transition(&"Attack")
	else:
		_transition(&"Idle")
