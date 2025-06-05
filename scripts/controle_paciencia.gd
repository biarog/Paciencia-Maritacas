extends Control

var movimento : Movimento_Jogo 
@onready var controle_deck := $"../Controle Deck"
@onready var controle_casas := $"../Controle Casas"

func _ready():
	await instancia_deck(Deck.cria_deck_desordenado(true))
	movimento = Movimento_Jogo.novo_movimento_jogo($"../Camada Drag")
	controle_deck.movimento = movimento
	get_parent().add_child.call_deferred(movimento)
	update_pos_containers()
	
	# Connectando sinais
	movimento.moveuCartas.connect(update_vis_cartas)
	movimento.soltouCartas.connect(update_pos_containers)
	movimento.soltandoCartas.connect(soltando_carta_check)
	
	for carta in get_tree().get_nodes_in_group("Cartas Jogo"):
		carta.connect("mouse_entered", _on_carta_mouse_entered)
		carta.connect("mouse_exited", _on_carta_mouse_exited)
		
	for coluna in get_tree().get_nodes_in_group("Areas Colunas Jogo"):
		coluna.mouse_entered.connect(Callable(self, "_on_area_coluna_mouse_entered").bind(coluna))
		coluna.mouse_exited.connect(_on_area_coluna_mouse_exited)

func _process(delta):
	movimento.processamento_movimento(delta)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			movimento.mouse_esq_press()
		else:
			movimento.mouse_esq_solta()


# Funções relacionadas ao movimento de cartas
func _on_carta_mouse_entered(carta:Carta):
	if carta.get_parent() != $"../Camada Drag":
		movimento.mouse_entrou_carta(carta)

func _on_carta_mouse_exited(carta:Carta):
	movimento.mouse_saiu_carta(carta)

func _on_area_coluna_mouse_entered(coluna):
	movimento._on_area_coluna_mouse_entered(coluna)

func _on_area_coluna_mouse_exited():
	movimento._on_area_coluna_mouse_exited()

# Funções para atualizar containers das colunas e visibilidade das cartas

func update_pos_containers():
	for coluna in get_tree().get_nodes_in_group("Colunas Jogo"):
		#var filhos = coluna.get_child_count()
		# Filhos - 2, pois um é para a carta (já que a posicção default do y é de 75
		# e o outro é para a própria AreaColuna que toda coluna possui
		#if (filhos-2 < 0) :
		#	filhos += 1;
		
		#coluna.get_child(0).position.y = 75 + ((filhos-2) * 25)
		
		for i in range(coluna.get_child_count()) :
			var child = coluna.get_child(i)
			child.z_index = i

func update_vis_cartas() -> void:
	for coluna in get_tree().get_nodes_in_group("Colunas Jogo"):
		var nfilhos = coluna.get_child_count()
		if nfilhos > 1 and coluna.get_child(nfilhos-1).virada:
			coluna.get_child(nfilhos-1).virar_carta()


# Função para instanciar o deck de cartas
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
		carta.add_to_group("Cartas Deck")
		deck_mesa.add_child(carta)
	
	update_vis_cartas()


# Funções da logica do paciencia

func soltando_carta_check(carta: Carta, em_coluna:bool, coluna_og:Control, coluna_nova:Control):
	var container_alvo = coluna_og
	print("coluna og:" + coluna_og.name)
	if em_coluna and coluna_nova != null and coluna_nova != coluna_og and !coluna_nova.is_in_group("Casas jogo"):
		var nfilhos = coluna_nova.get_child_count()
		if nfilhos > 1:
			var carta_mae = coluna_nova.get_child(nfilhos-1)
			if _comparar_cor(carta, carta_mae) and _comparar_valor(carta, carta_mae):
				container_alvo = coluna_nova
		else:
			if carta.valor == 13:
				container_alvo = coluna_nova
	
	movimento.soltando_cartas(container_alvo)

func _comparar_cor(carta1: Carta, carta2: Carta) -> bool:
	return carta1.cor != carta2.cor

func _comparar_valor(carta_nova: Carta, carta_mae: Carta) -> bool:
	return ((carta_mae.valor - carta_nova.valor) == 1)


# Funções para lógica do deck
# A ser adicionado
