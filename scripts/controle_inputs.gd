extends Control

#const COLISAO_CARTA : int = 1
#const COLISAO_SLOT_CARTA : int = 2

#func _input(event):
#	if event is InputEventMouseButton and event.keycode == MOUSE_BUTTON_LEFT:
#		if event.is_pressed():
#			raycast_cursor()
#		else:
#			pass

#func raycast_cursor():
#	var space_state = get_world_2d().direct_space_state
#	var parameters = PhysicsPointQueryParameters2D.new()
