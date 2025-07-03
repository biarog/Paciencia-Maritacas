extends Node2D

func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/mesa_paciencia.tscn")


func _on_creditos_pressed() -> void:
	$TextureRect2.hide()
	$MarginContainer.hide()
	$TextureRect.hide()
	$espada.hide()
	$coracao.hide()
	$Node2D.show()
	

func _on_texture_button_pressed() -> void:
	OS.shell_open("https://www.instagram.com/maritacasgamedev/")


func _on_fechar_pressed() -> void:
	$Node2D.hide()
	$TextureRect2.show()
	$MarginContainer.show()
	$TextureRect.show()
	$espada.show()
	$coracao.show()
	
