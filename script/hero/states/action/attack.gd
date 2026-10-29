extends HeroStateBase


@export var lock_speed: float = 50
@export var combo_animations: Array[StringName] = [&"attack", &"attack2", &"attack3"]
@export var animation_time: Array[float] = [-1.0, -1.0, -1.0]

var combo_index: int = 0
var combo_buffered: bool = false


func enter():
	combo_index = 0
	combo_buffered = false
	_start_attack()

func exit():
	pass

func update(_delta: float) -> StringName:
	if steering:
		steering.set_horizontal_velocity(hero.movement_direction * lock_speed)

	if Input.is_action_just_pressed("click"):
		combo_buffered = true
	return &""


func _start_attack():
	var anim_name := combo_animations[combo_index]
	var time := animation_time[combo_index]
	if time < 0:
		time = 0.4
	
	hero.play_animation(anim_name, time)
	_state_timer(time, _on_finished)

func _on_finished():
	if combo_buffered and combo_index < combo_animations.size() - 1:
		combo_index += 1
		combo_buffered = false
		_start_attack()
	else:
		_transition("Idle")
