extends CharacterBody2D

@export var speed := 400
@export var jump_velocity := 300

@export var sprite: AnimatedSprite2D
@export var visuals: Node2D
@export var animation_player: AnimationPlayer
@export var hit_box: Area2D


var is_attacking: bool


func _process(_delta: float) -> void:
	if abs(velocity.x) > 0:
		_flip(sign(velocity.x))
	
	if is_attacking:
		return
	
	if Input.is_action_just_pressed("click"):
		_attack()
		return
	
	if not is_on_floor():
		if velocity.y <= 0:
			sprite.animation = "jump_up"
		else:
			sprite.animation = "jump_down"
	elif abs(velocity.x) > 0:
		sprite.animation = "run"
	else:
		sprite.animation = "idle"


func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y += 900 * delta
	
	var input_direction := Input.get_axis("left", "right")
	velocity.x = input_direction * speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_velocity
	
	move_and_slide()


func _attack():
	is_attacking = true
	animation_player.play("attack")


func _finish_attack():
	is_attacking = false


func _flip(sign: float):
	visuals.scale.x = sign
	hit_box.scale.x = sign
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		_finish_attack()
