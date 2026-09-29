class_name CharacterStateAttack extends CharacterStateBase


@export var combo_animations: Array[StringName]


var combo_index: int
var combo_buffered: bool


func enter(from: CharacterStateBase):
	combo_index = 0
	combo_buffered = false
	character.animation_finished.connect(_on_animation_finished)
	character.play_animation("attack")


func exit(to: CharacterStateBase):
	character.animation_finished.disconnect(_on_animation_finished)


func handle_input() -> StringName:
	if Input.is_action_just_pressed("click") and combo_index < combo_animations.size():
		combo_buffered = true
	return ""
 

func _on_animation_finished(anim_name: StringName):
	if combo_buffered:
		combo_buffered = false
		character.play_animation(combo_animations[combo_index])
		combo_index += 1
		return
	if character.is_on_floor():
		_transition("idle")
	else:
		_transition("fall")
