class_name HeroAttackState extends HeroStateBase


@export var lock_speed: float = 50
@export var combo_animations: Array[StringName] = [&"attack", &"attack2", &"attack3"]
@export var animation_time: Array[float] = [-1.0, -1.0, -1.0]

var combo_index: int = 0


func enter():
	if hero.combo_buffered:
		combo_index += 1
		hero.combo_buffered = false
	else:
		combo_index = 0
	
	if combo_index >= combo_animations.size():
		_transition(&"Idle")
		return

	_start_attack()

func update(_delta: float) -> StringName:
	steering.set_horizontal_velocity(hero.movement_direction * lock_speed)
	
	if Input.is_action_just_pressed("click"):
		hero.combo_buffered = true
		
	return &""

func _start_attack():
	var anim_name := combo_animations[combo_index]
	var time := animation_time[combo_index]
	if time < 0:
		time = 0.4
	
	hero.play_animation(anim_name, time)
	_state_timer(time, _on_finished)

func _on_finished():
	if hero.combo_buffered:
		_transition(&"Attack")
	else:
		_transition(&"Idle")
