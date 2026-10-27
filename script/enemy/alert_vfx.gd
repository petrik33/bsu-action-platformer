extends VfxBase

@export var sprite: Sprite2D

var tween: Tween

func _ready() -> void:
	if sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("progress", 0.0)

func play(time: float) -> void:
	if tween and tween.is_valid():
		tween.kill()

	if sprite.material == null:
		return

	visible = true
	sprite.material.set_shader_parameter("progress", 0.0)
	
	scale = Vector2(0.85, 0.85)

	tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(sprite.material, "shader_parameter/progress", 1.0, time) \
		.set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(self, "scale", Vector2.ONE, time * 0.2) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "position:y", -12.0, time) \
		.as_relative().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.chain().tween_callback(stop)

func stop() -> void:
	if tween and tween.is_valid():
		tween.kill()
		tween = null

	visible = false
	if sprite.material:
		sprite.material.set_shader_parameter("progress", 0.0)
	
	sprite.position.y = 0.0
	scale = Vector2.ONE
