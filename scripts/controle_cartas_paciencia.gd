extends Control

var movimento : Movimento_Jogo 

func _ready():
	await instancia_deck(Deck.cria_deck_desordenado(true))
	var cartas := get_tree().get_nodes_in_group("Cartas Jogo")
	var colunas := get_tree().get_nodes_in_group("Colunas Jogo")
	var areas := get_tree().get_nodes_in_group("Areas Colunas Jogo")
	movimento = Movimento_Jogo.novo_movimento_jogo($"../Camada Drag", cartas, colunas, areas)
	get_parent().add_child.call_deferred(movimento)
	movimento.preparacao_mov()

func _process(delta):
	movimento.processamento_movimento(delta)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		movimento.mouse_esq(event)

# Função para instanciar o deck
func instancia_deck(deck_def:Array[Carta]):
	var colunas := get_tree().get_nodes_in_group("Colunas Jogo")
	var j := 0
	for i in range(28):
		var carta = deck_def[i]
		if ((i == 1) || (i == 3) || (i == 6) || (i == 10) || (i == 15) || (i == 21)):
			j = j + 1
		
		carta.add_to_group("Cartas Jogo")
		colunas[j].add_child(carta)
	
	for i in range(28,52):
		var deck_mesa := $"../Controle Deck/Deck"
		var carta = deck_def[i]
		deck_mesa.add_child(carta)

# Funções da logica do paciencia
