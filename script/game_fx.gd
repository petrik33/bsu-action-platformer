class_name GameFx extends Node

## Presentation controller that turns gameplay events into screen effects.
##
## Lives on the Game root. It owns the animation of post-processing effects
## (fade / pulse) so the effects themselves stay dumb, and it wires gameplay
## signals to them. Add more hooks here as the game grows.

@export var damage_effect: PostProcessEffect
@export var damage_flash_enabled: bool = true
@export var damage_flash_peak: float = 0.9
@export var damage_flash_duration: float = 0.35

var _hero: Hero
var _tweens: Dictionary = {}


func _ready() -> void:
	if damage_effect == null:
		damage_effect = get_tree().current_scene.find_child("DamageVignette", true, false) as PostProcessEffect

	_hero = get_tree().get_first_node_in_group(&"player") as Hero
	if _hero != null and _hero.hurt_box != null:
		_hero.hurt_box.hit_received.connect(_on_hero_hit)


## Animate an effect's strength to `value` over `duration` seconds.
func fade(effect: PostProcessEffect, value: float, duration: float = 0.3) -> void:
	if effect == null:
		return
	_kill_tween(effect)
	var tween := create_tween()
	tween.tween_method(effect.set_strength, effect.get_strength(), clampf(value, 0.0, 1.0), duration)
	tween.finished.connect(func() -> void: _tweens.erase(effect))
	_tweens[effect] = tween


## One-shot pulse: ramp up to `peak`, then back to 0.
func pulse(effect: PostProcessEffect, peak: float = 1.0, duration: float = 0.25) -> void:
	if effect == null:
		return
	_kill_tween(effect)
	var tween := create_tween()
	tween.tween_method(effect.set_strength, 0.0, clampf(peak, 0.0, 1.0), duration * 0.25)
	tween.tween_method(effect.set_strength, clampf(peak, 0.0, 1.0), 0.0, duration * 0.75)
	tween.finished.connect(func() -> void: _tweens.erase(effect))
	_tweens[effect] = tween


## Public hook for code that does not go through the player's hurt box.
func flash_damage() -> void:
	if damage_effect == null or not damage_flash_enabled:
		return
	pulse(damage_effect, damage_flash_peak, damage_flash_duration)


func _on_hero_hit(_attack: AttackData) -> void:
	flash_damage()


func _kill_tween(effect: PostProcessEffect) -> void:
	var tween: Tween = _tweens.get(effect)
	if tween and tween.is_valid():
		tween.kill()
	_tweens.erase(effect)
