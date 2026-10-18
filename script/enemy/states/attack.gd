extends EnemyCharacterStateBase


func enter():
	enemy.animation_finished.connect(_on_animation_finished)
	enemy.play_animation("attack")

func exit():
	enemy.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished():
	_transition(&"Idle")
