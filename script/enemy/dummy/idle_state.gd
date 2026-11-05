extends EnemyStateBase


@export var idle_animation: StringName = &"idle"

func enter():
	enemy.play_animation(idle_animation)
