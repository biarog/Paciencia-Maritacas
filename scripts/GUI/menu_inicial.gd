extends Node2D

var save = load("res://scripts/save.gd") #para poder carregar a clase "abstrata"


func _ready():		
	$som_musica_animada.volume_db = -15;
	if(save.get_mudo()):
		$MenuInicial/mudo.show()
	else:
		$MenuInicial/com_som.show()
	$som_musica_animada.play_override()

func _on_sair_pressed() -> void:
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play_override()
	get_tree().quit()

func _on_iniciar_pressed() -> void:
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play_override()
	get_tree().change_scene_to_file("res://cenas/mesa_paciencia.tscn")

func _on_creditos_pressed() -> void:
	$MenuInicial.hide()
	$Creditos.show()
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play_override()

func _on_texture_button_pressed() -> void:
	OS.shell_open("https://www.instagram.com/maritacasgamedev/")
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play_override()


func _on_fechar_pressed() -> void:
	$Creditos.hide()
	$MenuInicial.show()
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play_override()


func _on_botao_git_bia_pressed() -> void:
	OS.shell_open("https://github.com/biarog")
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play_override()


func _on_botao_git_matteo_pressed() -> void:
	OS.shell_open("https://github.com/matteosavan")
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play_override()


func _on_com_som_pressed() -> void:
	save.set_mudo(false)
	$MenuInicial/com_som.hide()
	$MenuInicial/mudo.show()
	save.set_mudo(true)
	$som_musica_animada.stop()

func _on_mudo_pressed() -> void:
	save.set_mudo(true)
	$MenuInicial/mudo.hide()
	$MenuInicial/com_som.show()
	$MenuInicial/MarginContainer/VBoxContainer/som_botao.play_override()
	save.set_mudo(false)
	$som_musica_animada.play_override()
	
	
