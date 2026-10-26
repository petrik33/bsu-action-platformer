class_name VfxAnimated extends VfxBase

@export var sprite: AnimatedSprite2D


func play(time: float):
	var anim_speed := Utils.get_sprite_animation_target_speed(sprite, &"alert", time)
	sprite.play(&"alert", anim_speed)

func stop():
	sprite.stop()
