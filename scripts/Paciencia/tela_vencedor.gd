extends Node2D


func _on_recomecar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/mesa_paciencia.tscn")

func _on_retornar_menu_inicial_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/menu_inicial.tscn")
