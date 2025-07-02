# Save.gd
extends Node
class_name Save
# vai conter dados da rodada

# Classe abstrata — não instanciar diretamente
# Variáveis privadas (por convenção, com underline)
var _tempo_segundos: int = 0
var _tempo_minutos: int = 0

# Getter e setter para tempo_segundos
func set_tempo_segundos(valor: int) -> void:
	_tempo_segundos = valor

func get_tempo_segundos() -> int:
	return _tempo_segundos

# Getter e setter para tempo_minutos
func set_tempo_minutos(valor: int) -> void:
	_tempo_minutos = valor

func get_tempo_minutos() -> int:
	return _tempo_minutos
