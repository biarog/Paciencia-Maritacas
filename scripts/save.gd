# Save.gd
extends Node
class_name Save
# vai conter dados da rodada

# Classe abstrata — não instanciar diretamente
# Variáveis privadas (por convenção, com underline)
static var _tempo:= 54
static var _mudo:= false


# Getter e setter para tempo_segundos
static func set_tempo(valor: int) -> void:
	_tempo = valor

static func get_tempo() -> int:
	return _tempo
	
static func get_tempo_string_pronta() -> String:
	var minu = int(_tempo/60.0)
	var seg = int(_tempo% 60) 
	return "%02d:%02d" % [minu, seg]
	
# Getter
static func get_mudo() -> bool:
	return _mudo

# Setter
static func set_mudo(valor: bool) -> void:
	_mudo = valor
