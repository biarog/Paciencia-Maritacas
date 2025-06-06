extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			_unpause_game()
		else:
			_pause_game()

func _pause_game():
	$MenuPausa.visible = true
	get_tree().paused = true

func _unpause_game():
	$MenuPausa.visible = false
	get_tree().paused = false

func _on_continue_pressed() -> void:
	_unpause_game()

func _on_retornar_menu_inicial_pressed() -> void:
	_unpause_game()
	get_tree().change_scene_to_file("res://cenas/menu_inicial.tscn")


func _on_recomecar_pressed() -> void:
	_unpause_game()
	get_tree().change_scene_to_file("res://cenas/mesa_paciencia.tscn")
