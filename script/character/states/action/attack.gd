extends GameCharacterStateBase


@export var lock_speed: float = 50
@export var combo_animations: Array[StringName] = [&"attack", &"attack2", &"attack3"]
@export var animation_time: Array[float] = [-1.0, -1.0, -1.0]

var combo_index: int = 0
var combo_buffered: bool = false


func enter():
	game_character.animation_finished.connect(_on_animation_finished)
	game_character.speed = lock_speed
	
	combo_index = 0
	combo_buffered = false
	_start_attack()

func exit():
	game_character.reset_speed()
	game_character.animation_finished.disconnect(_on_animation_finished)

func process(delta: float) -> StringName:
	if Input.is_action_just_pressed("click"):
		combo_buffered = true
	return ""


func _start_attack():
	game_character.play_animation(combo_animations[combo_index], animation_time[combo_index])

func _on_animation_finished():
	if combo_buffered and combo_index < combo_animations.size() - 1:
		combo_index += 1
		combo_buffered = false
		_start_attack()
	else:
		_transition("Idle")
