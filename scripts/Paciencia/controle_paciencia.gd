extends Control

var movimento : Movimento_Jogo 

func inicia_jogo():
	await instancia_deck(Deck.cria_deck_desordenado(true))

	update_pos_containers()
	
	# Connectando sinais
	movimento.moveuCartasColuna.connect(update_vis_cartas)
	movimento.soltouCartasColuna.connect(update_pos_containers)
	movimento.soltandoCartas.connect(soltando_carta_check)
	
	for carta in get_tree().get_nodes_in_group("Cartas Jogo"):
		conectar_carta(carta)
		
	for coluna in get_tree().get_nodes_in_group("Areas Colunas Jogo"):
		coluna.mouse_entered.connect(Callable(self, "_on_area_coluna_mouse_entered").bind(coluna))
		coluna.mouse_exited.connect(_on_area_coluna_mouse_exited)
	
	for casa in get_tree().get_nodes_in_group("Casas Jogo"):
		casa.mouse_entered.connect(Callable(self, "_on_area_coluna_mouse_entered").bind(casa))
		casa.mouse_exited.connect(_on_area_coluna_mouse_exited)

func _process(delta):
	movimento.processamento_movimento(delta)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			movimento.mouse_esq_press()
		else:
			movimento.mouse_esq_solta()


# Funções relacionadas ao movimento de cartas
func on_carta_mouse_entered(carta:Carta):
	if carta.get_parent() != $"../Camada Drag":
		movimento.mouse_entrou_carta(carta)

func on_carta_mouse_exited(carta:Carta):
	movimento.mouse_saiu_carta(carta)

func _on_area_coluna_mouse_entered(coluna):
	if coluna.is_in_group("Areas Colunas Jogo"):
		movimento._on_area_coluna_mouse_entered(coluna.get_parent())
	else:
		movimento._on_area_coluna_mouse_entered(coluna)

func _on_area_coluna_mouse_exited():
	movimento._on_area_coluna_mouse_exited()

# Funções para atualizar containers das colunas e visibilidade das cartas

func update_pos_containers():
	for coluna in get_tree().get_nodes_in_group("Colunas Jogo"):
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
		deck_mesa.add_child(carta)
	
	update_vis_cartas()


# Funções da logica do paciencia

func soltando_carta_check(carta: Carta, em_coluna:bool, coluna_og:Control, coluna_nova:Control):
	var container_alvo = coluna_og
	
	if em_coluna and coluna_nova != null and coluna_nova != coluna_og:
		var nfilhos:int = coluna_nova.get_child_count()
		var valor_para_vazio:int
		var bool_casas_jogo:bool = coluna_nova.is_in_group("Casas Jogo")
		if bool_casas_jogo: valor_para_vazio = 1
		else: valor_para_vazio = 13
		
		if nfilhos > 1: # Colunas normais tem areacoluna e as casas de jogo tem um sprite2d 
			var carta_mae = coluna_nova.get_child(nfilhos-1)
			if _comparar_cor(carta, carta_mae) and _comparar_valor_coluna(carta, carta_mae) and !bool_casas_jogo:
				container_alvo = coluna_nova
			if _comparar_naipe(carta, carta_mae) and _comparar_valor_casa(carta, carta_mae) and bool_casas_jogo:
				container_alvo = coluna_nova
		else:
			if carta.valor == valor_para_vazio:
				container_alvo = coluna_nova
		
	movimento.soltando_cartas(container_alvo, coluna_og)

# Retorna True se as cores entre duas cartas forem distintas
func _comparar_cor(carta1: Carta, carta2: Carta) -> bool:
	return carta1.cor != carta2.cor

# Retorna True se a diferença de valor entre a carta_mae e a carta_nova for de 1
func _comparar_valor_coluna(carta_nova: Carta, carta_mae: Carta) -> bool:
	return ((carta_mae.valor - carta_nova.valor) == 1)

func _comparar_valor_casa(carta_nova: Carta, carta_mae: Carta) -> bool:
	return ((carta_mae.valor - carta_nova.valor) == -1)

# Retorna True se carta1 e carta2 pertencerem ao mesmo naipe
func _comparar_naipe(carta1: Carta, carta2: Carta) -> bool:
	return carta1.naipe == carta2.naipe


func desconectar_carta(carta:Carta) -> void:
	if carta.is_connected("mouse_entered", on_carta_mouse_entered):
		carta.disconnect("mouse_entered", on_carta_mouse_entered)
	if carta.is_connected("mouse_exited", on_carta_mouse_exited):
		carta.disconnect("mouse_exited", on_carta_mouse_exited)
	

func conectar_carta(carta:Carta) -> void:
	carta.connect("mouse_entered", on_carta_mouse_entered)
	carta.connect("mouse_exited", on_carta_mouse_exited)
