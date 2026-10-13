extends CharacterStateBase


@export var lock_speed: float = 50

const COMBO_ANIMATIONS: Array[StringName] = [&"attack", &"attack2", &"attack3"]

var combo_index: int = 0
var combo_buffered: bool = false


func enter():
	character.animation_finished.connect(_on_animation_finished)
	character.speed = lock_speed
	
	combo_index = 0
	combo_buffered = false
	_start_attack()

func exit():
	character.reset_speed()
	character.animation_finished.disconnect(_on_animation_finished)

func handle_input() -> StringName:
	if Input.is_action_just_pressed("click"):
		combo_buffered = true
	return ""


func _start_attack():
	character.play_animation(COMBO_ANIMATIONS[combo_index])

func _on_animation_finished():
	if combo_buffered and combo_index < COMBO_ANIMATIONS.size() - 1:
		combo_index += 1
		combo_buffered = false
		_start_attack()
	else:
		_transition("Idle")
