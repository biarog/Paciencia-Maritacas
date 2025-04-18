extends Control

@export_enum('Ouros', 'Espadas', 'Copas', 'Paus') var casa
@export_range(1, 13) var valor : int
@export var imagem : Texture2D


func _on_area_carta_mouse_entered():
	var tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2(1.25,1.25), 0.1)
	

func _on_area_carta_mouse_exited():
	var tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2(1,1), 0.1)
	
