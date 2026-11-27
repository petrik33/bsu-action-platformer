class_name PostProcessEffect extends CanvasLayer

@export var material: ShaderMaterial:
	set(value):
		material = value
		if is_node_ready():
			_apply_material()

@export var strength: float = 1.0:
	get = get_strength,
	set = set_strength

var _rect: ColorRect


func _ready() -> void:
	if material == null:
		return

	_rect = ColorRect.new()
	_rect.name = "Screen"
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_rect)
	_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_rect.material = material


func _apply_material() -> void:
	if _rect:
		_rect.material = material


## Set any uniform on the active material.
func set_param(param_name: StringName, value: Variant) -> void:
	if material:
		material.set_shader_parameter(param_name, value)


## 0 = original image, 1 = full effect.
func set_strength(value: float) -> void:
	if material:
		material.set_shader_parameter(&"strength", clampf(value, 0.0, 1.0))


func get_strength() -> float:
	if material:
		var value: Variant = material.get_shader_parameter(&"strength")
		return float(value) if value != null else 0.0
	return 0.0
