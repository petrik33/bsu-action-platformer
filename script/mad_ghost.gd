extends CharacterBody2D


@export var hover_height := 5
@export var height_lerp := 0.2


@export var ground_ray: RayCast2D
@export var hurt_box: Area2D
@export var sprite: AnimatedSprite2D


func _physics_process(_delta):
	move_and_slide()

	ground_ray.force_raycast_update()
	if ground_ray.is_colliding():
		var ground_y = ground_ray.get_collision_point().y
		var target_y = ground_y - hover_height
		position.y = lerp(position.y, target_y, height_lerp)


func _on_hurt_box_area_entered(area: Area2D) -> void:
	sprite.animation = "hurt"


func _on_hurt_box_area_exited(area: Area2D) -> void:
	sprite.animation = "idle"
