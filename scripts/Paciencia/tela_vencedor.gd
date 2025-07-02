extends Node2D

func _ready() -> void:
	var Save = load("res://scripts/save.gd") #para poder carregar a clase "abstrata"
	print(Save.get_tempo_string_pronta())
	$TelaVencedor/Panel/CenterContainerTempo/Label.text = Save.get_tempo_string_pronta()
	

func _on_recomecar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/mesa_paciencia.tscn")

func _on_retornar_menu_inicial_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/menu_inicial.tscn")
