extends HeroStateBase




func update(_delta: float) -> StringName:
	if Input.is_action_just_pressed("jump"):
		return "Jump"
	
	if Input.is_action_just_pressed("click"):
		return "Attack"
	
	if Input.is_action_just_pressed("roll"):
		return "Roll"
	
	if not hero.is_on_floor():
		return "Fall"
	
	return &""
