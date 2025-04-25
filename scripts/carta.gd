extends Control

@export_enum('Ouros', 'Espadas', 'Copas', 'Paus') var casa
@export_range(1, 13) var valor : int
@export var imagem : Texture2D

func _on_area_carta_mouse_entered():
	emit_signal("mouse_entered", self)

func _on_area_carta_mouse_exited():
	emit_signal("mouse_exited", self)
