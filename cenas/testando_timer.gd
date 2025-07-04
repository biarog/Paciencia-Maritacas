extends Node2D

var tempo_total = 0

func _ready() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	tempo_total = tempo_total+1
	print(tempo_total)
	$CenterContainer/Label.text = formatar_tempo(tempo_total)

func formatar_tempo(segundos: float) -> String:
	var min = int(segundos) / 60
	var seg = int(segundos) % 60
	return "%02d:%02d" % [min, seg]
