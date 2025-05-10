extends Control

@export_enum('Ouros', 'Espadas', 'Copas', 'Paus') var casa
@export_range(1, 13) var valor : int

func _ready():
	var sprite_carta = $"Sprite Carta"
	sprite_carta.frame_coords = Vector2((valor-1), casa)

func _on_area_carta_mouse_entered():
	emit_signal("mouse_entered", self)

func _on_area_carta_mouse_exited():
	emit_signal("mouse_exited", self)
