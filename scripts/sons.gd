extends AudioStreamPlayer

var save = load("res://scripts/save.gd")

func play_override(from_position: float = 0.0):
	if(!save.get_mudo() and self.is_inside_tree()):
		self.play(from_position)
