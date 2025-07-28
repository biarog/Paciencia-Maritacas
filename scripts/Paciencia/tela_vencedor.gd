extends Node2D

var musica := preload("res://sons/som_palmas(1).wav")

var save = load("res://scripts/save.gd") #para poder carregar a clase "abstrata"


func _ready() -> void:
	
	var save = load("res://scripts/save.gd") #para poder carregar a clase "abstrata"
	$TelaVencedor/Label.text = save.get_tempo_string_pronta()
	$TelaVencedor/Panel/CenterContainerTrofeu/ImagemTrofeu/AnimationPlayer.play("sumido e surgindo")
	await get_tree().create_timer(2.0).timeout
	$TelaVencedor/Panel/CenterContainerTrofeu/ImagemTrofeu/AnimationPlayer.play("trofeu subindo")
	$som_palmas.stream = musica
	$som_palmas.play()
	await get_tree().create_timer(1.0).timeout
	$TelaVencedor/Parabens.modulate.a = 0.0  # Começa invisível
	$TelaVencedor/Label.modulate.a = 0.0
	$TelaVencedor/Parabens.visible = true
	$TelaVencedor/Label.visible = true
	
	var tween = create_tween()
	tween.tween_property($TelaVencedor/Parabens, "modulate:a", 1.0, 2.0)
	tween.tween_property($TelaVencedor/Label, "modulate:a", 1.0, 2.0)
	
	$TelaVencedor/Parabens.iniciar()
	await get_tree().create_timer(1.0).timeout
	
	$TelaVencedor/Control/AnimatedSprite2D_firework.show()
	$TelaVencedor/Control/AnimatedSprite2D_firework.play("firework")
	await get_tree().create_timer(1.0).timeout
	$TelaVencedor/Control/AnimatedSprite2D_firework2.show()
	$TelaVencedor/Control/AnimatedSprite2D_firework3.show()
	$TelaVencedor/Control/AnimatedSprite2D_firework2.play("firework")
	$TelaVencedor/Control/AnimatedSprite2D_firework3.play("firework")
	await get_tree().create_timer(1.0).timeout
	$TelaVencedor/Control/AnimatedSprite2D_firework4.show()
	$TelaVencedor/Control/AnimatedSprite2D_firework5.show()
	$TelaVencedor/Control/AnimatedSprite2D_firework4.play("firework")
	$TelaVencedor/Control/AnimatedSprite2D_firework5.play("firework")
	await get_tree().create_timer(1.0).timeout
	$TelaVencedor/Control/AnimatedSprite2D_firework6.show()
	$TelaVencedor/Control/AnimatedSprite2D_firework6.play("firework")
	
	var tween2 = create_tween()
	$TelaVencedor/Panel/CenterContainerBotoes.modulate.a = 0.0
	$TelaVencedor/Panel/CenterContainerBotoes.show()
	tween2.tween_property($TelaVencedor/Panel/CenterContainerBotoes, "modulate:a", 1.0, 2.0)
	

func _on_recomecar_pressed() -> void:
	if(!save.get_mudo()):
		$som_botao.play()
		await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://cenas/mesa_paciencia.tscn")


func _on_retornar_menu_inicial_pressed() -> void:
	if(!save.get_mudo()):
		$som_botao.play()
		await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://cenas/menu_inicial.tscn")
