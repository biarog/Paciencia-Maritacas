extends Node2D

var tempo_total = 0

func _ready() -> void:
	$NoTimer.start()

func formatar_tempo(segundos: float) -> String:
	var minu = int(segundos / 60.0)
	var seg = int(segundos) % 60
	return "%02d:%02d" % [minu, seg]

func salvar_tempo():
	var save = load("res://scripts/save.gd")
	save.set_tempo(tempo_total)
	print("salvou")

func _on_no_timer_timeout() -> void:
	tempo_total = tempo_total+1
	$CenterContainer/Label.text = formatar_tempo(tempo_total)
