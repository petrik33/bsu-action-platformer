extends EnemyCharacterStateBase

func enter():
	enemy.stop_horizontal()
	enemy.animation_finished.connect(_on_animation_finished)
	enemy.play_animation(&"hurt")

func exit():
	enemy.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished():
	_transition(&"Idle")
