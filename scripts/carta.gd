class_name Carta extends Control

@export_enum('Ouros', 'Espadas', 'Copas', 'Paus') var casa
@export_range(1, 13) var valor : int
@export var virada : bool = false
var cor : bool

const CARTA_SCENE: PackedScene = preload("res://cenas/carta.tscn")

func _on_area_carta_mouse_entered():
	emit_signal("mouse_entered", self)

func _on_area_carta_mouse_exited():
	emit_signal("mouse_exited", self)

func _set_frame(casa_def:int, valor_def:int):
	var sprite_carta = $"Sprite Carta"
	sprite_carta.frame_coords = Vector2((valor_def-1), casa_def)

func _set_sprite_virada() -> void:
	var sprite_virada := $"SpriteVirada Carta"
	sprite_virada.visible = virada

func virar_carta():
	var animacao:AnimationPlayer = $AnimationVirar
	if virada:
		animacao.play_backwards("virar_carta")
	else:
		animacao.play("virar_carta")
	virada = !virada

func _set_cor():
	cor = casa % 2

static func cria_nova_carta(casa_def:int, valor_def:int, virada_def:bool) -> Carta :
	casa_def = clamp(casa_def, 0, 3)
	valor_def = clamp(valor_def, 1, 13)
	var nova_carta = CARTA_SCENE.instantiate()
	nova_carta.casa = casa_def
	nova_carta.valor = valor_def
	nova_carta.virada = virada_def
	nova_carta._set_sprite_virada()
	nova_carta._set_frame(casa_def, valor_def)
	nova_carta._set_cor()
	return nova_carta
