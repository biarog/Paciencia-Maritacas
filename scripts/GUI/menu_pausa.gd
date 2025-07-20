extends CanvasLayer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if get_tree().paused:
			hide()
			get_tree().paused = false
