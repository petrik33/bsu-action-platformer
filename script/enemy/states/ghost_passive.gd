class_name GhostPassiveState extends EnemyPassiveState

func enter() -> void:
	enemy.play_animation(&"idle")

func update(delta: float) -> StringName:
	var transition = super.update(delta)
	if transition != &"":
		return transition

	# Use the Waving component if present
	var waving = enemy.find_child("*Waving*", true) as Waving
	if waving:
		waving.apply_wave(delta)
	
	return &""
