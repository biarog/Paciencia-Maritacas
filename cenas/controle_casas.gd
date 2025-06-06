extends Control

var movimento:Movimento_Jogo
@onready var casas:Array[Node]
@onready var controle_jogo := $"../Controle Jogo"
@onready var controle_deck := $"../Controle Deck"

func _ready() -> void:
	casas = get_tree().get_nodes_in_group("Casas Jogo")
	movimento.soltouCartaCasa.connect(_normalizar_zindex)
	movimento.soltouCartaCasa.connect(_atualizar_conexoes)
	movimento.moveuCartaCasa.connect(_atualizar_conexoes)

func _normalizar_zindex() -> void:
	for casa in casas:
		for i in range(casa.get_child_count()):
			var child = casa.get_child(i)
			child.z_index = 0

func _atualizar_conexoes() -> void:
	for casa in casas:
		if casa.get_child_count() > 1:
			for i in range(1, casa.get_child_count()):
				var carta = casa.get_child(i)
				controle_jogo.desconectar_carta(carta)
				
			controle_jogo.conectar_carta(casa.get_child(casa.get_child_count()-1))
	check_vitoria()


func check_vitoria():
	var venceu:bool = true
	for casa in casas:
		if casa.get_child_count() < 14:
			venceu = false
	
	if venceu:
		print("YIPPEEE, voce venceu paciencia!!!!")
		get_tree().reload_current_scene()
