class_name HitBox extends Area2D

signal hit(hurt_box: HurtBox)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		hit.emit(area)
