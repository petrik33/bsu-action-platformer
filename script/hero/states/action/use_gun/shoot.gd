extends HeroStateBase

@export var anim_name: StringName = &"shoot"
@export var next_shot_min_time: float = 0.1
@export var time: float = 0.3
@export var anim_observer: AnimationObserver
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 900
@export var bullet_origin: Node2D
@export var bullet_next_origin: Node2D
@export_range(0.0, 1.0) var shot_trauma: float = 0.5


func enter():
	hero.play_animation(anim_name, time, true)
	anim_observer.subscribe_entered(_on_shoot_frame_entered)
	_schedule_transition(time, &"Idle")

func exit():
	anim_observer.unsubscribe_entered(_on_shoot_frame_entered)

func update(delta: float) -> StringName:
	if not Input.is_action_just_pressed("shoot"):
		return &""
	_transition_after(next_shot_min_time, &"Shoot")
	return &""


func _on_shoot_frame_entered():
	var from := bullet_origin.global_position if bullet_origin != null else hero.global_position
	var bullet := Projectiles.spawn(
		bullet_scene, from, Vector2.RIGHT * hero.facing_direction(), hero, bullet_speed
	)
	if bullet == null:
		return
	if bullet_next_origin != null:
		bullet.move_to(bullet_next_origin.global_position)
	hero.shot_fired.emit(shot_trauma)
