extends CharacterBody2D

@export var speed := 400
@export var jump_velocity := 300

@export var sprite: AnimatedSprite2D
@export var visuals: Node2D


func _process(_delta: float) -> void:
	if not is_on_floor():
		if velocity.y <= 0:
			sprite.animation = "jump_up"
		else:
			sprite.animation = "jump_down"
	elif abs(velocity.x) > 0:
		sprite.animation = "run"
	else:
		sprite.animation = "idle"
		
	if abs(velocity.x) > 0:
		visuals.scale.x = abs(visuals.scale.x) * sign(velocity.x)


func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y += 900 * delta
	
	var input_direction := Input.get_axis("left", "right")
	velocity.x = input_direction * speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_velocity
	
	move_and_slide()
