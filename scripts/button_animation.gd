extends Button

var escala_og : Vector2 = self.scale

@export var multiplier = 1.1
@export var timer = 0.1

func _ready() -> void:
	if self.has_signal("mouse_entered"):
		self.mouse_entered.connect(_on_mouse_entered_button)
	if self.has_signal("mouse_exited"):
		self.mouse_exited.connect(_on_mouse_exited_button)
	self.pivot_offset = size/2

func _on_mouse_entered_button() -> void:
	_change_button(escala_og*multiplier)

func _on_mouse_exited_button() -> void:
	_change_button(escala_og)

func _change_button(end_scale) -> void:
	var tween : Tween = self.create_tween()
	tween.tween_property(self, "scale", end_scale, timer)
