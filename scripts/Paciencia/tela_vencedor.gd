extends Node2D

func _ready() -> void:
	var Save = load("res://scripts/save.gd") #para poder carregar a clase "abstrata"
	print(Save.get_tempo_string_pronta())
	$TelaVencedor/Label.text = Save.get_tempo_string_pronta()
	$TelaVencedor/AnimatedSprite2D_firework.play("firework")
	$TelaVencedor/AnimatedSprite2D_firework2.play("firework")
	$TelaVencedor/AnimatedSprite2D_firework3.play("firework")
	$TelaVencedor/AnimatedSprite2D_firework4.play("firework")
	$TelaVencedor/AnimatedSprite2D_firework5.play("firework")
	$TelaVencedor/AnimatedSprite2D_firework6.play("firework")
	
	
	

func _on_recomecar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/mesa_paciencia.tscn")

func _on_retornar_menu_inicial_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/menu_inicial.tscn")
