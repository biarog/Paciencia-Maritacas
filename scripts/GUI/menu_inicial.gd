extends Node2D


func _on_sair_pressed() -> void:
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play()
	get_tree().quit()
	


func _on_iniciar_pressed() -> void:
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play()
	get_tree().change_scene_to_file("res://cenas/mesa_paciencia.tscn")

func _on_creditos_pressed() -> void:
	$MenuInicial.hide()
	$Creditos.show()
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play()

func _on_texture_button_pressed() -> void:
	OS.shell_open("https://www.instagram.com/maritacasgamedev/")
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play()
	


func _on_fechar_pressed() -> void:
	$Creditos.hide()
	$MenuInicial.show()
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play()
	
	


func _on_botao_git_bia_pressed() -> void:
	OS.shell_open("https://github.com/biarog")
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play()
	


func _on_botao_git_matteo_pressed() -> void:
	OS.shell_open("https://github.com/matteosavan")
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play()
	
